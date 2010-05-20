package MooseX::Types::Meta;
BEGIN {
  $MooseX::Types::Meta::AUTHORITY = 'cpan:FLORA';
}
BEGIN {
  $MooseX::Types::Meta::VERSION = '0.01';
}
# ABSTRACT: Moose types to check against Moose's meta objects

use Moose 1.05 ();
use MooseX::Types -declare => [qw(
    TypeConstraint
    TypeCoercion
    Attribute
    RoleAttribute
    Method
    Class
    Role

    TypeEquals
    TypeOf
    SubtypeOf

    StructuredTypeConstraint
    StructuredTypeCoercion

    ParameterizableRole
    ParameterizedRole

)];
use Carp qw(confess);
use namespace::clean;

# TODO: ParameterizedType{Constraint,Coercion} ?
#       {Duck,Class,Enum,Parameterizable,Parameterized,Role,Union}TypeConstraint?


class_type TypeConstraint, { class => 'Moose::Meta::TypeConstraint' };


class_type TypeCoercion,   { class => 'Moose::Meta::TypeCoercion' };


class_type Attribute,      { class => 'Class::MOP::Attribute' };


class_type RoleAttribute,  { class => 'Moose::Meta::Role::Attribute' };


class_type Method,         { class => 'Class::MOP::Method' };


class_type Class,          { class => 'Class::MOP::Class' };


class_type Role,           { class => 'Moose::Meta::Role' };


class_type StructuredTypeConstraint, {
    class => 'MooseX::Meta::TypeConstraint::Structured',
};


class_type StructuredTypeCoercion, {
    class => 'MooseX::Meta::TypeCoercion::Structured',
};


class_type ParameterizableRole, {
    class => 'MooseX::Role::Parameterized::Meta::Role::Parameterizable',
};


class_type ParameterizedRole, {
    class => 'MooseX::Role::Parameterized::Meta::Role::Parameterized',
};


for my $t (
    [ 'TypeEquals', 'equals'        ],
    [ 'TypeOf',     'is_a_type_of'  ],
    [ 'SubtypeOf',  'is_subtype_of' ],
) {
    my ($name, $method) = @{ $t };
    my $tc = Moose::Meta::TypeConstraint::Parameterizable->new(
        name                 => join(q{::} => __PACKAGE__, $name),
        package_defined_in   => __PACKAGE__,
        parent               => TypeConstraint,
        constraint_generator => sub {
            my ($type_parameter) = @_;
            confess "type parameter $type_parameter for $name is not a type constraint"
                unless TypeConstraint->check($type_parameter);
            return sub {
                my ($val) = @_;
                return $val->$method($type_parameter);
            };
        },
    );

    Moose::Util::TypeConstraints::register_type_constraint($tc);
    Moose::Util::TypeConstraints::add_parameterizable_type($tc);
}

__PACKAGE__->meta->make_immutable;

1;

__END__
=pod

=head1 NAME

MooseX::Types::Meta - Moose types to check against Moose's meta objects

=head1 TYPES

=head2 TypeConstraint

A L<Moose::Meta::TypeConstraint>.

=head2 TypeCoercion

A L<Moose::Meta::TypeCoercion>.

=head2 Attribute

A L<Class::MOP::Attribute>.

=head2 RoleAttribute

A L<Moose::Meta::Role::Attribute>.

=head2 Method

A L<Class::MOP::Method>.

=head2 Class

A L<Class::MOP::Class>.

=head2 Role

A L<Moose::Meta::Role>.

=head2 StructuredTypeConstraint

A L<MooseX::Meta::TypeConstraint::Structured>.

=head2 StructuredTypeCoercion

A L<MooseX::Meta::TypeCoercion::Structured>.

=head2 ParameterizableRole

A L<MooseX::Role::Parameterized::Meta::Role::Parameterizable>.

=head2 ParameterizedRole

A L<MooseX::Role::Parameterized::Meta::Role::Parameterized>.

=head2 TypeEquals[`x]

A L<Moose::Meta::TypeConstraint>, that's equal to the type constraint
C<x>.

=head2 TypeOf[`x]

A L<Moose::Meta::TypeConstraint>, that's either equal to or a subtype
of the type constraint C<x>.

=head2 SubtypeOf[`x]

A L<Moose::Meta::TypeConstraint>, that's a subtype of the type
constraint C<x>.

=head1 AUTHOR

  Florian Ragwitz <rafl@debian.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2010 by Florian Ragwitz.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

