
"""
Ponycheck is a library for property based testing
with tight integration into ponytest.

## Property Based Testing

In _traditional_ unit testing the developer specifies one or more input
examples manually for the class or system under test and assert on certain
output conditions. The difficulty here is to find enough examples to cover
all branches and cases of the class or system under test.

In property bases testing the developer defines a property, a kind of predicate
for the class or system under test that should hold for all kinds or just a
subset of possible input values. The property based testing engine then
generates a big number of random input values and checks if the property holds
for all of them. The developer only needs to specify the possible set of input values
using a Generator.

This testing technique is great for finding edge cases that would easily go unnoticed
with manually constructed test samples. In general it can lead to much higher
coverage than traditional unit-testing, with much less code to write.

## How Ponycheck implements Property Based Testing

A property based test in ponycheck consists of the following:

* A name (for integration into ponytest mostly)
* One or more generators, depending on how your property is layed out.
  There are tons of them defined on primitive
  [Generators](ponycheck-Generators.md).
* A `property` method that asserts a certain property for each sample
  generated by the [Generator(s)](ponycheck-Generator.md) with the help of
  [PropertyHelper](ponycheck-PropertyHelper.md) which tries to expose a similar API
  as [TestHelper](ponytest-TestHelper.md).
* Optionally, the method ``params()`` can be used to configure how ponycheck executes
  the property by specifying a custom [PropertyParams](ponycheck-PropertyParams.md) object.

The classical list-reverse example:

```pony
use "collections"
use "ponycheck"

class ListReverseProperty is Property1[List[USize]]
  fun name(): String => "list/reverse"

  fun gen(): Generator[List[USize]] =>
    Generators.list_of[USize](Generators.usize())

  fun property(arg1: List[USize], ph: PropertyHelper) =>
    ph.array_eq[USize](arg1, arg1.reverse().reverse())
```

## Integration into Ponytest

There are two ways of integrating a [Property](ponycheck-Property1.md) into
[ponytest](ponytest--index.md):

1. In order to pass your Property to the ponytest engine, you need to wrap it inside a [Property1UnitTest](ponycheck-Property1UnitTest.md).

```pony
   actor Main is TestList
     new create(env: Env) => PonyTest(env, this)

     fun tag tests(test: PonyTest) =>
       test(Property1UnitTest[String](MyStringProperty))
```

2. Run as much [Properties](ponycheck-Property1.md) as you wish inside one ponytest
   [UnitTest](ponytest-UnitTest.md) using the convenience function
   [Ponycheck.for_all](ponycheck-Ponycheck.md#for_all) providing a
   [Generator](ponycheck-Generator), the [TestHelper](ponytest-TestHelper.md) and the
   actual property function. (Note that the property function is supplied in a
   second application of the result to `for_all`.)

```pony
   class ListReversePropertyWithinAUnitTest is UnitTest
     fun name(): String => "list/reverse/forall"

     fun apply(h: TestHelper) =>
       let gen = recover val Generators.list_of[USize](Generators.usize()) end
       Ponycheck.for_all[List[USize]](gen, h)(
         {(sample, ph) =>
           ph.array_eq[Usize](arg1, arg1.reverse().reverse())
         })
       // ... possibly more properties, using ``Ponycheck.for_all``
```

Independent of how you integrate with [ponytest](ponytest--index.md),
the ponycheck machinery will instantiate the provided Generator, and will
execute it for a configurable number of samples.

If the property fails using an assertion method of
[PropertyHelper](ponycheck-PropertyHelper.md),
the failed example will be shrunken by the generator
to obtain a smaller and more informative, still failing, sample
for reporting.

"""
use "ponytest"

primitive Ponycheck
  fun for_all[T](gen: Generator[T] val, h: TestHelper): ForAll[T] =>
    """
    convenience method for running 1 to many properties as part of
    one ponytest UnitTest.

    Example:

    ```pony
      class MyTestWithSomeProperties is UnitTest
        fun name(): String => "mytest/withMultipleProperties"

        fun apply(h: TestHelper) =>
          Ponycheck.for_all[U8](recover Generators.unit[U8](0) end, h)(
            {(u, h) =>
              h.assert_eq(u, 0)
              consume u
            })
    ```
    """
    ForAll[T](gen, h)

  fun for_all2[T1, T2](
    gen1: Generator[T1] val,
    gen2: Generator[T2] val,
    h: TestHelper)
    : ForAll2[T1, T2]
  =>
    ForAll2[T1, T2](gen1, gen2, h)

  fun for_all3[T1, T2, T3](
    gen1: Generator[T1] val,
    gen2: Generator[T2] val,
    gen3: Generator[T3] val,
    h: TestHelper)
    : ForAll3[T1, T2, T3]
  =>
    ForAll3[T1, T2, T3](gen1, gen2, gen3, h)

  fun for_all4[T1, T2, T3, T4](
    gen1: Generator[T1] val,
    gen2: Generator[T2] val,
    gen3: Generator[T3] val,
    gen4: Generator[T4] val,
    h: TestHelper)
    : ForAll4[T1, T2, T3, T4]
  =>
    ForAll4[T1, T2, T3, T4](gen1, gen2, gen3, gen4, h)
