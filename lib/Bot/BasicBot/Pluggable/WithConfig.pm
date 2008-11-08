package Bot::BasicBot::Pluggable::WithConfig;

use strict;
use warnings;
use base qw(Bot::BasicBot::Pluggable);
our $VERSION = '0.01';
use YAML;

sub new_with_config {
    my $class = shift;
    my %args  = @_;

    my $conf = YAML::LoadFile( $args{config} )
        or die "Can't load a config file";

    my @modules = @{ delete $conf->{modules} || [] };
    my $bot = $class->new( %{ $conf || {} } );

    foreach my $module (@modules) {
        $bot->load( $module->{name}, $module->{config} );
    }

    $bot;
}

1;

__END__

=head1 NAME

Bot::BasicBot::Pluggable::WithConfig - initialize bot instance with YAML config

=head1 SYNOPSIS
Create a new Bot with YAML file.

  use Bot::BasicBot::Pluggable::WithConfig;

  my $bot = Bot::BasicBot::Pluggable->new_with_config(
    config => '/etc/pluggablebot.yaml'
  );

  ex) YAML configuration
  server:   irc.example.net
  port:     6667
  nick:     pluggablebot
  username: pluggablebot
  charset:  utf-8
  store:
    type:  Bot::BasicBot::Pluggable::Store::DBI
    dsn:   dbi:SQLite:dann.db
    table: pluggablebot
  modules:
    - name: Karma
    - name: Seen
    - name: Infobot
    - name: Title
  channels:
    - #pluggablebot

=head1 DESCRIPTION

Bot::BasicBot::Pluggable::WithConfig is instance creator with config file

=head1 AUTHOR

Takatoshi Kitano E<lt>kitano.tk {at} gmail.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
