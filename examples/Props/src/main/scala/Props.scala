import scala.compiletime.*
import scala.deriving.Mirror
import scala.quoted.*

class Props extends Selectable:

  def selectDynamic(name: String): Any =
    "prop for " + name

transparent inline def props[T] =
  ${ propsImpl[T] }

private def propsImpl[T: Type](using Quotes): Expr[Any] =
  import quotes.reflect.*

  Expr.summon[Mirror.ProductOf[T]].get match
    case '{ $m: Mirror.ProductOf[T] { type MirroredElemLabels = mels; type MirroredElemTypes = mets } } =>
      Type.of[mels] match
        case '[mel *: melTail] =>
          val label = Type.valueOfConstant[mel].get.toString

          Refinement(TypeRepr.of[Props], label, TypeRepr.of[String]).asType match
            case '[tpe] =>
              val res = '{
                val p = Props()
                p.asInstanceOf[tpe]
              }
              println(res.show)
              res
