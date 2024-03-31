import shapeless.::
import shapeless.HNil

import eu.timepit.refined.api.Refined
import eu.timepit.refined.auto._
import eu.timepit.refined.boolean.{AllOf, Not, Or, And}
import eu.timepit.refined.char.LetterOrDigit
import eu.timepit.refined.collection.{NonEmpty, MaxSize, Tail}
import eu.timepit.refined.generic.Equal
import eu.timepit.refined.string.{MatchesRegex, StartsWith}

// see https://kwark.github.io/refined-in-practice/#20
object refinements:

  type Name = String Refined NonEmpty
  type TwitterHandle = String Refined StartsWith["@"]

  final case class Developer(name: Name, twitterHandle: TwitterHandle)

  def run: Unit =
    val name: Name = "Tom".asInstanceOf[Name]
    val x = Developer(name, "@tom_76".asInstanceOf[TwitterHandle])
    assert(x.name.length > 0)

// see https://kwark.github.io/refined-in-practice/#49
object improved:

  type Name = String Refined And[NonEmpty, MaxSize[256]]
  type TwitterHandle = String Refined AllOf[
    StartsWith["@"] ::
    MaxSize[16] ::
    Not[MatchesRegex["(?i:.*twitter.*)"]] ::
    Not[MatchesRegex["(?i:.*admin.*)"]] ::
    Tail[Or[LetterOrDigit, Equal['_']]] ::
    HNil
  ]

  final case class Developer(name: Name, twitterHandle: TwitterHandle)

  def run: Unit =
    val name: Name = "Tom".asInstanceOf[Name]
    val x = Developer(name, "@tom_76".asInstanceOf[TwitterHandle])
    assert(x.name.length > 0)

@main def Main: Unit =
  refinements.run
  improved.run
