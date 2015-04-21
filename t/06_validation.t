#!/usr/bin/env perl

use Test::More;
use Test::Exception;

use Moose::Util::TypeConstraints;

subtype 'TestModel::StrStartsWithA', as 'Str', where { $_ =~ m/^a/ };

package TestModel {
  use MooseX::DataModel;
  key att1 => (isa => 'TestModel::StrStartsWithA');
  array att2 => (isa => 'TestModel::StrStartsWithA');
  object att3 => (isa => 'TestModel::StrStartsWithA');

  key class1 => (isa => 'TestModel::Class');
  key class2 => (isa => 'TestModel::Class');
}

package TestModel::Class {
  use MooseX::DataModel;
  key att1 => (isa => 'Str');
}

{ 
  my $ds = { att1 => 'is invalid' };

  dies_ok(sub {
    TestModel->new_from_data($ds);
  });
}

{ 
  my $ds = { att1 => 'a value that starts with a' };

  lives_ok(sub {
    TestModel->new_from_data($ds);
  });
}

{
  my $ds = { att2 => [ 'is invalid' ] };

  dies_ok(sub {
    TestModel->new_from_data($ds);
  });
}

{
  my $ds = { att2 => [ 'a value that starts with a' ] };

  lives_ok(sub {
    TestModel->new_from_data($ds);
  });
}

{
  my $ds = { att3 => { k1 => 'is invalid' } };

  dies_ok(sub {
    TestModel->new_from_data($ds);
  });
}

{
  my $ds = { att3 => { k1 => 'a value that starts with a' } };

  lives_ok(sub {
    TestModel->new_from_data($ds);
  });
}


done_testing;
