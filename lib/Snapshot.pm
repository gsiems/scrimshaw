package Snapshot;

use File::Path qw(make_path);
use POSIX qw(strftime);
use Sys::Hostname;

sub host {
    my $host = hostname;

    if ( $host =~ m/^localhost/i ) {
        my $cmd = q{/sbin/ifconfig | grep ether | awk '{print $2}'};
        ($host) = `$cmd`;
        chomp $host;
        $host =~ s/:/-/g;
    }

    return $host;
}

sub current_tmsp {
    return strftime( '%Y%m%d.%s', localtime );
}

sub backup_base_dir {
    my ($base_dir) = @_;
    return join( '/', $base_dir, 'backups', host() );
}

sub mk_dir {
    my ($dir) = shift;
    ( -d $dir ) || make_path($dir);
    ( -d $dir ) || die "$dir does not exists and an error occured while trying to create it. $!";
}

sub init_backup_base_dir {
    my ($base_dir) = shift;
    my $backup_base_dir = backup_base_dir($base_dir);
    mk_dir($backup_base_dir);
    return $backup_base_dir;
}

sub read_last_good {
    my ($backup_base_dir) = @_;
    my $last_good = join ("/", $backup_base_dir, 'last_backup');

    if ( -f $last_good ) {
        return slurp($last_good);
    }
    return undef;
}

sub write_last_good {
    my ($backup_dir) = @_;

    my $snapshot_dir = (split ('/', $backup_dir))[-1];
    my $last_good = $backup_dir;
    $last_good =~ s|[^/]+$|last_backup|;

    open( my $fh, '>', $last_good ) || die "Could not open $last_good for output. $!";
    print $fh "$snapshot_dir";
    close $fh;
}

sub read_config {
    my ($base_dir) = @_;
    my $config_file = join ("/", $base_dir, 'snapshot.config');

    my %config;
    if ( -f $config_file ) {
        my $data = slurp($config_file);
        if ($data) {

            # Filter out the empty lines and commented-out lines
            my @ary = grep { $_ !~ m/^\s*$/ } grep { $_ !~ m/^\s*#/ } split /\n/, $data;

            foreach my $line (@ary) {
                my ($key, $value) = split /\s*[=#]\s*/, $line, 2;
                $value =~ s/\s+$//;
                if ($key eq 'source') {
                    $config{$key}{$value} = 1;
                }
                else {
                    $config{$key} = $value;
                }
            }
        }
    }
    $config{save_count} ||= 20;

    return %config;
}

sub calc_interval {
    my ($backup_interval) = @_;
    return 0 unless ($backup_interval);

    my $interval = 0;
    my %multipliers = (
        s => 1,
        m => 60,
        h => 3600,
        d => 86400,
    );

    foreach my $token (split /\s+/, $backup_interval) {
        my ($num, $unit) = split /(d|h|m|s)/, $token;
        next unless ($num && $unit);
        if ($multipliers{$unit}) {
            $interval += $num * $multipliers{$unit};
        }
    }
    return $interval;
}

sub slurp { local ( *ARGV, $/ ); @ARGV = shift; <> }

1;
