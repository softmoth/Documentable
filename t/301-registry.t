use Test;

use Documentable;
use Documentable::Registry;
use Pod::Load;

my $registry = Documentable::Registry.new(
    :topdir("t/test-doc"),
    :dirs(["Programs", "Native"]),
    :verbose(False),
);

subtest "Processing pod dir" => {
    my @documents = ("Debugging", "Reading", "int", "pod1", "pod2");
    is-deeply $registry.documentables.map({.name}).sort.Array,
              @documents,
              "All pods have been processed";
}

subtest "Composing" => {
    $registry.compose;

    my @documents = ("Debugging", "Reading", "int", "pod1", "pod2");
    is $registry.composed, True, "Composed set to True";
    my @definitions = ("ACCEPTS", "any", "mro", "new reference", "root");
    my @references = ("aa", "meta (multi)", "nometa", "part", "url");
    is-deeply $registry.definitions.map({.name}).sort.Array,
              @definitions,
              "All definitions has been found";
    is-deeply $registry.references.map({.name}).sort.Array,
              @references,
              "All references has been found";
    is-deeply $registry.docs.map({.name}).sort,
              (@documents,@definitions,@references).flat.sort,
              "All references has been found";
}

subtest "Lookup by kind" => {
    is $registry.lookup(Kind::Type.Str, :by<kind>).map({.name}).sort,
       ["int", "pod1", "pod2"],
       "Lookup by Kind::Type";
    is $registry.lookup(Kind::Programs.Str, :by<kind>).map({.name}).sort,
       ["Debugging", "Reading"],
       "Lookup by Kind::Programs";
}

subtest 'docs-for' => {
    my $doc = $registry.docs.grep({.name eq "int"});
    is-deeply $registry.docs-for("int"), $doc, "basic search";
}

done-testing;
