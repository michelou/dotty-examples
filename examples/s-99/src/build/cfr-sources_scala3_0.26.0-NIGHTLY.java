// Compiled with scala3_0.26.0-bin-20200710-a162b7b-NIGHTLY-git-a162b7b 
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.App;
import scala.Predef$;
import scala.collection.immutable.List;
import scala.collection.immutable.Seq;
import scala.collection.mutable.ListBuffer;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.ScalaRunTime$;

public final class Main$
implements App,
Serializable {
    public static final Main$ MODULE$;
    private long executionStart;
    private String[] scala$App$$_args;
    private ListBuffer scala$App$$initCode;
    private final List xs;
    private final List ys;

    public static {
        new Main$();
    }

    private Main$() {
        MODULE$ = this;
        App.$init$(this);
        this.xs = (List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.wrapIntArray(new int[]{1, 2, 3, 4, 5}));
        this.ys = (List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.wrapIntArray(new int[]{1, 2, 3, 4, 5, 8}));
        Predef$.MODULE$.println("Given:");
        Predef$.MODULE$.println("   xs = " + this.xs());
        Predef$.MODULE$.println("   ys = " + this.ys());
        Predef$.MODULE$.println();
        Predef$.MODULE$.println("P01.lastBuiltin(" + this.xs() + ") = " + P01$.MODULE$.lastBuiltin(this.xs()));
        Predef$.MODULE$.println();
        Predef$.MODULE$.println("P02.penultimateBuiltin(" + this.ys() + ") = " + P02$.MODULE$.penultimateBuiltin(this.ys()));
        Predef$.MODULE$.println("P02.lastNthBuiltin(2, " + this.ys() + ") = " + P02$.MODULE$.lastNthBuiltin(2, this.ys()));
        Predef$.MODULE$.println();
        Predef$.MODULE$.println("P03.nthBuiltin(2, " + this.ys() + ") = " + P03$.MODULE$.nthBuiltin(2, this.ys()));
        Predef$.MODULE$.println("P03.nthRecursive(2, " + this.ys() + ") = " + P03$.MODULE$.nthRecursive(2, this.ys()));
        Predef$.MODULE$.println();
        Predef$.MODULE$.println("P04.lengthBuiltin(" + this.xs() + ") = " + P04$.MODULE$.lengthBuiltin(this.xs()));
    }

    @Override
    public final long executionStart() {
        return this.executionStart;
    }

    @Override
    public String[] scala$App$$_args() {
        return this.scala$App$$_args;
    }

    public ListBuffer scala$App$$initCode() {
        return this.scala$App$$initCode;
    }

    @Override
    public void scala$App$$_args_$eq(String[] x$1) {
        this.scala$App$$_args = x$1;
    }

    @Override
    public void scala$App$_setter_$executionStart_$eq(long x$0) {
        this.executionStart = x$0;
    }

    public void scala$App$_setter_$scala$App$$initCode_$eq(ListBuffer x$0) {
        this.scala$App$$initCode = x$0;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(Main$.class);
    }

    public List<Object> xs() {
        return this.xs;
    }

    public List<Object> ys() {
        return this.ys;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Function0;
import scala.collection.immutable.List;
import scala.collection.mutable.ListBuffer;

public final class Main {
    public static void delayedInit(Function0 function0) {
        Main$.MODULE$.delayedInit(function0);
    }

    public static long executionStart() {
        return Main$.MODULE$.executionStart();
    }

    public static void main(String[] arrstring) {
        Main$.MODULE$.main(arrstring);
    }

    public static List xs() {
        return Main$.MODULE$.xs();
    }

    public static List ys() {
        return Main$.MODULE$.ys();
    }

    public static void scala$App$_setter_$executionStart_$eq(long l) {
        Main$.MODULE$.scala$App$_setter_$executionStart_$eq(l);
    }

    public static void scala$App$_setter_$scala$App$$initCode_$eq(ListBuffer listBuffer) {
        Main$.MODULE$.scala$App$_setter_$scala$App$$initCode_$eq(listBuffer);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import java.util.NoSuchElementException;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;

public final class P01$
implements Serializable {
    public static final P01$ MODULE$;

    public static {
        new P01$();
    }

    private P01$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P01$.class);
    }

    public <A> A lastBuiltin(List<A> ls) {
        return ls.last();
    }

    public <A> A lastRecursive(List<A> ls) {
        Object h;
        block4: {
            List<A> list;
            List<A> list2 = ls;
            while ((list = list2) instanceof $colon$colon) {
                $colon$colon $colon$colon = ($colon$colon)list;
                List list3 = $colon$colon.next$access$1();
                h = $colon$colon.head();
                Nil$ nil$ = package$.MODULE$.Nil();
                List list4 = list3;
                if (nil$ == null) {
                    if (list4 == null) break block4;
                } else if (((Object)nil$).equals(list4)) break block4;
                List tail = list3;
                list2 = tail;
            }
            throw new NoSuchElementException();
        }
        return h;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P01 {
    public static <A> A lastBuiltin(List<A> list) {
        return P01$.MODULE$.lastBuiltin(list);
    }

    public static <A> A lastRecursive(List<A> list) {
        return P01$.MODULE$.lastRecursive(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import java.util.NoSuchElementException;
import scala.MatchError;
import scala.collection.AbstractIterable;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;

public final class P02$
implements Serializable {
    public static final P02$ MODULE$;

    public static {
        new P02$();
    }

    private P02$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P02$.class);
    }

    public <A> A penultimateBuiltin(List<A> ls) {
        if (ls.isEmpty()) {
            throw new NoSuchElementException();
        }
        return ((List)ls.init()).last();
    }

    public <A> A penultimateRecursive(List<A> ls) {
        Object h;
        block5: {
            List<A> list;
            List<A> list2 = ls;
            while ((list = list2) instanceof $colon$colon) {
                $colon$colon $colon$colon = ($colon$colon)list;
                List list3 = $colon$colon.next$access$1();
                h = $colon$colon.head();
                if (list3 instanceof $colon$colon) {
                    List list4 = (($colon$colon)list3).next$access$1();
                    Nil$ nil$ = package$.MODULE$.Nil();
                    List list5 = list4;
                    if (nil$ == null) {
                        if (list5 == null) break block5;
                    } else if (((Object)nil$).equals(list5)) break block5;
                }
                List tail = list3;
                list2 = tail;
            }
            throw new NoSuchElementException();
        }
        return h;
    }

    public <A> A lastNthBuiltin(int n, List<A> ls) {
        if (n <= 0) {
            throw new IllegalArgumentException();
        }
        if (ls.length() < n) {
            throw new NoSuchElementException();
        }
        return ((AbstractIterable)ls.takeRight(n)).head();
    }

    public <A> A lastNthRecursive(int n, List<A> ls) {
        if (n <= 0) {
            throw new IllegalArgumentException();
        }
        return (A)this.lastNthR$1(n, ls, ls);
    }

    private final Object lastNthR$1(int count, List resultList, List curList) {
        List list;
        block3: {
            List list2;
            List list3 = curList;
            list = resultList;
            int n = count;
            while (true) {
                List list4;
                list2 = list3;
                Nil$ nil$ = package$.MODULE$.Nil();
                List list5 = list2;
                if (!(nil$ != null ? !((Object)nil$).equals(list5) : list5 != null)) {
                    if (n > 0) {
                        throw new NoSuchElementException();
                    }
                    break block3;
                }
                if (!(list2 instanceof $colon$colon)) break;
                List tail = list4 = (($colon$colon)list2).next$access$1();
                int n2 = n - 1;
                List list6 = n > 0 ? list : (List)list.tail();
                List list7 = tail;
                n = n2;
                list = list6;
                list3 = list7;
            }
            throw new MatchError(list2);
        }
        return list.head();
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P02 {
    public static <A> A lastNthBuiltin(int n, List<A> list) {
        return P02$.MODULE$.lastNthBuiltin(n, list);
    }

    public static <A> A lastNthRecursive(int n, List<A> list) {
        return P02$.MODULE$.lastNthRecursive(n, list);
    }

    public static <A> A penultimateBuiltin(List<A> list) {
        return P02$.MODULE$.penultimateBuiltin(list);
    }

    public static <A> A penultimateRecursive(List<A> list) {
        return P02$.MODULE$.penultimateRecursive(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import java.util.NoSuchElementException;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P03$
implements Serializable {
    public static final P03$ MODULE$;

    public static {
        new P03$();
    }

    private P03$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P03$.class);
    }

    public <A> A nthBuiltin(int n, List<A> ls) {
        if (n < 0) {
            throw new NoSuchElementException();
        }
        return ls.apply(n);
    }

    public <A> A nthRecursive(int n, List<A> ls) {
        List<A> list;
        block3: {
            Tuple2<Integer, List<A>> tuple2;
            List<A> list2 = ls;
            int n2 = n;
            while ((tuple2 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n2), list2)) != null) {
                int n3 = BoxesRunTime.unboxToInt(tuple2._1());
                list = tuple2._2();
                if (0 != n3 || !(list instanceof $colon$colon)) {
                    int n4 = n3;
                    if (list instanceof $colon$colon) {
                        List list3;
                        List tail = list3 = (($colon$colon)list).next$access$1();
                        int n5 = n4 - 1;
                        List list4 = tail;
                        n2 = n5;
                        list2 = list4;
                        continue;
                    }
                    Nil$ nil$ = package$.MODULE$.Nil();
                    List<A> list5 = list;
                    if (nil$ != null ? !((Object)nil$).equals(list5) : list5 != null) break;
                    throw new NoSuchElementException();
                }
                break block3;
            }
            throw new MatchError(tuple2);
        }
        List list6 = (($colon$colon)list).next$access$1();
        Object h = (($colon$colon)list).head();
        return h;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P03 {
    public static <A> A nthBuiltin(int n, List<A> list) {
        return P03$.MODULE$.nthBuiltin(n, list);
    }

    public static <A> A nthRecursive(int n, List<A> list) {
        return P03$.MODULE$.nthRecursive(n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P04$
implements Serializable {
    public static final P04$ MODULE$;

    public static {
        new P04$();
    }

    private P04$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P04$.class);
    }

    public <A> int lengthBuiltin(List<A> ls) {
        return ls.length();
    }

    public <A> int lengthRecursive(List<A> ls) {
        int n;
        List<A> list = ls;
        Nil$ nil$ = package$.MODULE$.Nil();
        List<A> list2 = list;
        if (!(nil$ != null ? !((Object)nil$).equals(list2) : list2 != null)) {
            n = 0;
        } else if (list instanceof $colon$colon) {
            List list3;
            List tail = list3 = (($colon$colon)list).next$access$1();
            n = 1 + this.lengthRecursive(tail);
        } else {
            throw new MatchError(list);
        }
        return n;
    }

    public <A> int lengthTailRecursive(List<A> ls) {
        return this.lengthR$1(0, ls);
    }

    public <A> int lengthFunctional(List<A> ls) {
        return BoxesRunTime.unboxToInt(ls.foldLeft(BoxesRunTime.boxToInteger(0), (arg_0, arg_1) -> this.lengthFunctional$$anonfun$adapted$1(arg_0, arg_1)));
    }

    private final int lengthR$1(int result, List curList) {
        int n;
        block1: {
            List list;
            List list2 = curList;
            n = result;
            while (true) {
                List list3;
                list = list2;
                Nil$ nil$ = package$.MODULE$.Nil();
                List list4 = list;
                if (!(nil$ == null ? list4 != null : !((Object)nil$).equals(list4))) break block1;
                if (!(list instanceof $colon$colon)) break;
                List tail = list3 = (($colon$colon)list).next$access$1();
                int n2 = n + 1;
                List list5 = tail;
                n = n2;
                list2 = list5;
            }
            throw new MatchError(list);
        }
        return n;
    }

    private final /* synthetic */ int lengthFunctional$$anonfun$1(int c, Object _$1) {
        return c + 1;
    }

    private final int lengthFunctional$$anonfun$adapted$1(Object c, Object _$1) {
        return this.lengthFunctional$$anonfun$1(BoxesRunTime.unboxToInt(c), _$1);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P04 {
    public static <A> int lengthBuiltin(List<A> list) {
        return P04$.MODULE$.lengthBuiltin(list);
    }

    public static <A> int lengthFunctional(List<A> list) {
        return P04$.MODULE$.lengthFunctional(list);
    }

    public static <A> int lengthRecursive(List<A> list) {
        return P04$.MODULE$.lengthRecursive(list);
    }

    public static <A> int lengthTailRecursive(List<A> list) {
        return P04$.MODULE$.lengthTailRecursive(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.collection.immutable.Seq;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.ScalaRunTime$;

public final class P05$
implements Serializable {
    public static final P05$ MODULE$;

    public static {
        new P05$();
    }

    private P05$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P05$.class);
    }

    public <A> List<A> reverseBuiltin(List<A> ls) {
        return ls.reverse();
    }

    public <A> List<A> reverseRecursive(List<A> ls) {
        List list;
        List<A> list2 = ls;
        Nil$ nil$ = package$.MODULE$.Nil();
        List<A> list3 = list2;
        if (!(nil$ != null ? !((Object)nil$).equals(list3) : list3 != null)) {
            list = package$.MODULE$.Nil();
        } else if (list2 instanceof $colon$colon) {
            $colon$colon $colon$colon = ($colon$colon)list2;
            List list4 = $colon$colon.next$access$1();
            Object h = $colon$colon.head();
            List tail = list4;
            List list5 = this.reverseRecursive(tail);
            list = ((List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Object[]{h}))).$colon$colon$colon(list5);
        } else {
            throw new MatchError(list2);
        }
        return list;
    }

    public <A> List<A> reverseTailRecursive(List<A> ls) {
        return this.reverseR$1(package$.MODULE$.Nil(), ls);
    }

    public <A> List<A> reverseFunctional(List<A> ls) {
        return (List)ls.foldLeft(package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Object[0])), (r, h) -> r.$colon$colon(h));
    }

    private final List reverseR$1(List result, List curList) {
        List list;
        block1: {
            List list2;
            List list3 = curList;
            list = result;
            while (true) {
                list2 = list3;
                Nil$ nil$ = package$.MODULE$.Nil();
                List list4 = list2;
                if (!(nil$ == null ? list4 != null : !((Object)nil$).equals(list4))) break block1;
                if (!(list2 instanceof $colon$colon)) break;
                $colon$colon $colon$colon = ($colon$colon)list2;
                List list5 = $colon$colon.next$access$1();
                Object h = $colon$colon.head();
                List tail = list5;
                List list6 = list.$colon$colon(h);
                List list7 = tail;
                list = list6;
                list3 = list7;
            }
            throw new MatchError(list2);
        }
        return list;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P05 {
    public static <A> List<A> reverseBuiltin(List<A> list) {
        return P05$.MODULE$.reverseBuiltin(list);
    }

    public static <A> List<A> reverseFunctional(List<A> list) {
        return P05$.MODULE$.reverseFunctional(list);
    }

    public static <A> List<A> reverseRecursive(List<A> list) {
        return P05$.MODULE$.reverseRecursive(list);
    }

    public static <A> List<A> reverseTailRecursive(List<A> list) {
        return P05$.MODULE$.reverseTailRecursive(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.collection.immutable.List;
import scala.runtime.ModuleSerializationProxy;

public final class P06$
implements Serializable {
    public static final P06$ MODULE$;

    public static {
        new P06$();
    }

    private P06$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P06$.class);
    }

    public <A> boolean isPalindrome(List<A> ls) {
        List<A> list = ls;
        Object object = ls.reverse();
        return !(list != null ? !((Object)list).equals(object) : object != null);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P06 {
    public static <A> boolean isPalindrome(List<A> list) {
        return P06$.MODULE$.isPalindrome(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Function1;
import scala.collection.IterableOnce;
import scala.collection.immutable.List;
import scala.collection.immutable.Seq;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.ScalaRunTime$;

public final class P07$
implements Serializable {
    public static final P07$ MODULE$;

    public static {
        new P07$();
    }

    private P07$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P07$.class);
    }

    public List<Object> flatten(List<Object> ls) {
        return ls.flatMap((Function1<Object, IterableOnce> & Serializable)x$1 -> {
            List list;
            Object object = x$1;
            if (object instanceof List) {
                List ms = (List)object;
                list = this.flatten(ms);
            } else {
                Object e = object;
                list = (List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Object[]{e}));
            }
            return list;
        });
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P07 {
    public static List<Object> flatten(List<Object> list) {
        return P07$.MODULE$.flatten(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.collection.immutable.Seq;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.ScalaRunTime$;

public final class P08$
implements Serializable {
    public static final P08$ MODULE$;

    public static {
        new P08$();
    }

    private P08$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P08$.class);
    }

    public <A> List<A> compressRecursive(List<A> ls) {
        List list;
        List<A> list2 = ls;
        Nil$ nil$ = package$.MODULE$.Nil();
        List<A> list3 = list2;
        if (!(nil$ != null ? !((Object)nil$).equals(list3) : list3 != null)) {
            list = package$.MODULE$.Nil();
        } else if (list2 instanceof $colon$colon) {
            $colon$colon $colon$colon = ($colon$colon)list2;
            List list4 = $colon$colon.next$access$1();
            Object h = $colon$colon.head();
            List tail = list4;
            list = this.compressRecursive((List)tail.dropWhile(_$1 -> BoxesRunTime.equals(_$1, h))).$colon$colon(h);
        } else {
            throw new MatchError(list2);
        }
        return list;
    }

    public <A> List<A> compressTailRecursive(List<A> ls) {
        return this.compressR$1(package$.MODULE$.Nil(), ls);
    }

    public <A> List<A> compressFunctional(List<A> ls) {
        return (List)ls.foldRight(package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Object[0])), (h, r) -> r.isEmpty() || !BoxesRunTime.equals(r.head(), h) ? r.$colon$colon(h) : r);
    }

    private final List compressR$1(List result, List curList) {
        List list;
        block4: {
            List list2;
            block5: {
                List list3;
                Nil$ nil$;
                block3: {
                    List list4 = curList;
                    list = result;
                    while ((list2 = list4) instanceof $colon$colon) {
                        $colon$colon $colon$colon = ($colon$colon)list2;
                        List list5 = $colon$colon.next$access$1();
                        Object h = $colon$colon.head();
                        List tail = list5;
                        List list6 = list.$colon$colon(h);
                        List list7 = (List)tail.dropWhile(_$2 -> BoxesRunTime.equals(_$2, h));
                        list = list6;
                        list4 = list7;
                    }
                    nil$ = package$.MODULE$.Nil();
                    list3 = list2;
                    if (nil$ != null) break block3;
                    if (list3 == null) break block4;
                    break block5;
                }
                if (((Object)nil$).equals(list3)) break block4;
            }
            throw new MatchError(list2);
        }
        return list.reverse();
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P08 {
    public static <A> List<A> compressFunctional(List<A> list) {
        return P08$.MODULE$.compressFunctional(list);
    }

    public static <A> List<A> compressRecursive(List<A> list) {
        return P08$.MODULE$.compressRecursive(list);
    }

    public static <A> List<A> compressTailRecursive(List<A> list) {
        return P08$.MODULE$.compressTailRecursive(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.collection.immutable.Seq;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.Nothing$;
import scala.runtime.ScalaRunTime$;

public final class P09$
implements Serializable {
    public static final P09$ MODULE$;

    public static {
        new P09$();
    }

    private P09$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P09$.class);
    }

    public <A> List<List<A>> pack(List<A> ls) {
        List list;
        if (ls.isEmpty()) {
            list = (List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.wrapRefArray(new List[]{(List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Nothing$[0]))}));
        } else {
            List<A> next;
            Tuple2<List<A>, List<A>> tuple2 = ls.span(_$1 -> BoxesRunTime.equals(_$1, ls.head()));
            if (!(tuple2 instanceof Tuple2)) {
                throw new MatchError(tuple2);
            }
            Tuple2<List<A>, List<A>> tuple22 = tuple2;
            List<A> packed = tuple22._1();
            List<A> next2 = tuple22._2();
            Tuple2<List<A>, List<A>> tuple23 = Tuple2$.MODULE$.apply(packed, next2);
            List<A> packed2 = tuple23._1();
            List<A> list2 = next = tuple23._2();
            Nil$ nil$ = package$.MODULE$.Nil();
            list = !(list2 != null ? !((Object)list2).equals(nil$) : nil$ != null) ? (List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.wrapRefArray(new List[]{packed2})) : this.pack(next).$colon$colon(packed2);
        }
        return list;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P09 {
    public static <A> List<List<A>> pack(List<A> list) {
        return P09$.MODULE$.pack(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.List;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P10$
implements Serializable {
    public static final P10$ MODULE$;

    public static {
        new P10$();
    }

    private P10$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P10$.class);
    }

    public <A> List<Tuple2<Object, A>> encode(List<A> ls) {
        return P09$.MODULE$.pack(ls).map(e -> Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(e.length()), e.head()));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Tuple2;
import scala.collection.immutable.List;

public final class P10 {
    public static <A> List<Tuple2<Object, A>> encode(List<A> list) {
        return P10$.MODULE$.encode(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Tuple2;
import scala.collection.immutable.List;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;
import scala.util.Either;

public final class P11$
implements Serializable {
    public static final P11$ MODULE$;

    public static {
        new P11$();
    }

    private P11$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P11$.class);
    }

    public <A> List<Object> encodeModified(List<A> ls) {
        return P10$.MODULE$.encode(ls).map(t -> BoxesRunTime.unboxToInt(t._1()) == 1 ? t._2() : t);
    }

    public <A> List<Either<A, Tuple2<Object, A>>> encodeModified2(List<A> ls) {
        return P10$.MODULE$.encode(ls).map(t -> BoxesRunTime.unboxToInt(t._1()) == 1 ? package$.MODULE$.Left().apply(t._2()) : package$.MODULE$.Right().apply(t));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Tuple2;
import scala.collection.immutable.List;
import scala.util.Either;

public final class P11 {
    public static <A> List<Object> encodeModified(List<A> list) {
        return P11$.MODULE$.encodeModified(list);
    }

    public static <A> List<Either<A, Tuple2<Object, A>>> encodeModified2(List<A> list) {
        return P11$.MODULE$.encodeModified2(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Tuple2;
import scala.collection.immutable.List;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P12$
implements Serializable {
    public static final P12$ MODULE$;

    public static {
        new P12$();
    }

    private P12$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P12$.class);
    }

    public <A> List<A> decode(List<Tuple2<Object, A>> ls) {
        return ls.flatMap(e -> package$.MODULE$.List().fill(BoxesRunTime.unboxToInt(e._1()), () -> this.decode$$anonfun$2$$anonfun$1(e)));
    }

    private final Object decode$$anonfun$2$$anonfun$1(Tuple2 e$1) {
        return e$1._2();
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Tuple2;
import scala.collection.immutable.List;

public final class P12 {
    public static <A> List<A> decode(List<Tuple2<Object, A>> list) {
        return P12$.MODULE$.decode(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.List;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P13$
implements Serializable {
    public static final P13$ MODULE$;

    public static {
        new P13$();
    }

    private P13$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P13$.class);
    }

    public <A> List<Tuple2<Object, A>> encodeDirect(List<A> ls) {
        List list;
        if (ls.isEmpty()) {
            list = package$.MODULE$.Nil();
        } else {
            Tuple2<List<A>, List<A>> tuple2 = ls.span(_$1 -> BoxesRunTime.equals(_$1, ls.head()));
            if (!(tuple2 instanceof Tuple2)) {
                throw new MatchError(tuple2);
            }
            Tuple2<List<A>, List<A>> tuple22 = tuple2;
            List<A> packed = tuple22._1();
            List<A> next = tuple22._2();
            Tuple2<List<A>, List<A>> tuple23 = Tuple2$.MODULE$.apply(packed, next);
            List<A> packed2 = tuple23._1();
            List<A> next2 = tuple23._2();
            Tuple2 tuple24 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(packed2.length()), packed2.head());
            list = this.encodeDirect(next2).$colon$colon(tuple24);
        }
        return list;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Tuple2;
import scala.collection.immutable.List;

public final class P13 {
    public static <A> List<Tuple2<Object, A>> encodeDirect(List<A> list) {
        return P13$.MODULE$.encodeDirect(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Function1;
import scala.collection.IterableOnce;
import scala.collection.immutable.List;
import scala.collection.immutable.Seq;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.ScalaRunTime$;

public final class P14$
implements Serializable {
    public static final P14$ MODULE$;

    public static {
        new P14$();
    }

    private P14$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P14$.class);
    }

    public <A> List<A> duplicate(List<A> ls) {
        return ls.flatMap((Function1<Object, IterableOnce> & Serializable)e -> (IterableOnce)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Object[]{e, e})));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P14 {
    public static <A> List<A> duplicate(List<A> list) {
        return P14$.MODULE$.duplicate(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Function1;
import scala.collection.IterableOnce;
import scala.collection.immutable.List;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;

public final class P15$
implements Serializable {
    public static final P15$ MODULE$;

    public static {
        new P15$();
    }

    private P15$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P15$.class);
    }

    public <A> List<A> duplicateN(int n, List<A> ls) {
        return ls.flatMap((Function1<Object, IterableOnce> & Serializable)_$1 -> package$.MODULE$.List().fill(n, () -> this.duplicateN$$anonfun$2$$anonfun$1(_$1)));
    }

    private final Object duplicateN$$anonfun$2$$anonfun$1(Object _$1$1) {
        return _$1$1;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P15 {
    public static <A> List<A> duplicateN(int n, List<A> list) {
        return P15$.MODULE$.duplicateN(n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P16$
implements Serializable {
    public static final P16$ MODULE$;

    public static {
        new P16$();
    }

    private P16$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P16$.class);
    }

    public <A> List<A> dropRecursive(int n, List<A> ls) {
        return this.dropR$1(n, n, ls);
    }

    public <A> List<A> dropTailRecursive(int n, List<A> ls) {
        return this.dropR$2(n, n, ls, package$.MODULE$.Nil());
    }

    public <A> List<A> dropFunctional(int n, List<A> ls) {
        return ((List)((List)ls.zipWithIndex()).filter(v -> (BoxesRunTime.unboxToInt(v._2()) + 1) % n != 0)).map(_$1 -> _$1._1());
    }

    private final List dropR$1(int n$1, int c, List curList) {
        List list;
        block4: {
            Tuple2<Integer, List> tuple2;
            List list2 = curList;
            int n = c;
            while ((tuple2 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n), list2)) != null) {
                List list3 = tuple2._2();
                Nil$ nil$ = package$.MODULE$.Nil();
                List list4 = list3;
                if (!(nil$ != null ? !((Object)nil$).equals(list4) : list4 != null)) {
                    list = package$.MODULE$.Nil();
                } else {
                    if (1 == BoxesRunTime.unboxToInt(tuple2._1()) && list3 instanceof $colon$colon) {
                        List list5;
                        List tail = list5 = (($colon$colon)list3).next$access$1();
                        int n2 = n$1;
                        List list6 = tail;
                        n = n2;
                        list2 = list6;
                        continue;
                    }
                    if (!(list3 instanceof $colon$colon)) break;
                    $colon$colon $colon$colon = ($colon$colon)list3;
                    List list7 = $colon$colon.next$access$1();
                    Object h = $colon$colon.head();
                    List tail = list7;
                    list = this.dropR$1(n$1, n - 1, tail).$colon$colon(h);
                }
                break block4;
            }
            throw new MatchError(tuple2);
        }
        return list;
    }

    private final List dropR$2(int n$2, int c, List curList, List result) {
        List list;
        block3: {
            Tuple2<Integer, List> tuple2;
            list = result;
            List list2 = curList;
            int n = c;
            while ((tuple2 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n), list2)) != null) {
                List list3 = tuple2._2();
                Nil$ nil$ = package$.MODULE$.Nil();
                List list4 = list3;
                if (nil$ == null ? list4 != null : !((Object)nil$).equals(list4)) {
                    if (1 == BoxesRunTime.unboxToInt(tuple2._1()) && list3 instanceof $colon$colon) {
                        List list5;
                        List tail = list5 = (($colon$colon)list3).next$access$1();
                        int n2 = n$2;
                        List list6 = tail;
                        n = n2;
                        list2 = list6;
                        continue;
                    }
                    if (!(list3 instanceof $colon$colon)) break;
                    $colon$colon $colon$colon = ($colon$colon)list3;
                    List list7 = $colon$colon.next$access$1();
                    Object h = $colon$colon.head();
                    List tail = list7;
                    int n3 = n - 1;
                    List list8 = tail;
                    List list9 = list.$colon$colon(h);
                    n = n3;
                    list2 = list8;
                    list = list9;
                    continue;
                }
                break block3;
            }
            throw new MatchError(tuple2);
        }
        return list.reverse();
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P16 {
    public static <A> List<A> dropFunctional(int n, List<A> list) {
        return P16$.MODULE$.dropFunctional(n, list);
    }

    public static <A> List<A> dropRecursive(int n, List<A> list) {
        return P16$.MODULE$.dropRecursive(n, list);
    }

    public static <A> List<A> dropTailRecursive(int n, List<A> list) {
        return P16$.MODULE$.dropTailRecursive(n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P17$
implements Serializable {
    public static final P17$ MODULE$;

    public static {
        new P17$();
    }

    private P17$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P17$.class);
    }

    public <A> Tuple2<List<A>, List<A>> splitBuiltin(int n, List<A> ls) {
        return ls.splitAt(n);
    }

    /*
     * Enabled force condition propagation
     * Lifted jumps to return sites
     */
    public <A> Tuple2<List<A>, List<A>> splitRecursive(int n, List<A> ls) {
        Tuple2<List<A>, List<A>> tuple2;
        Tuple2<Integer, List<A>> tuple22 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n), ls);
        if (tuple22 == null) throw new MatchError(tuple22);
        int n2 = BoxesRunTime.unboxToInt(tuple22._1());
        List<A> list = tuple22._2();
        Nil$ nil$ = package$.MODULE$.Nil();
        List<A> list2 = list;
        if (!(nil$ != null ? !((Object)nil$).equals(list2) : list2 != null)) {
            tuple2 = Tuple2$.MODULE$.apply(package$.MODULE$.Nil(), package$.MODULE$.Nil());
            return tuple2;
        } else if (0 == n2) {
            List<A> list3 = list;
            tuple2 = Tuple2$.MODULE$.apply(package$.MODULE$.Nil(), list3);
            return tuple2;
        } else {
            int n3 = n2;
            if (!(list instanceof $colon$colon)) throw new MatchError(tuple22);
            $colon$colon $colon$colon = ($colon$colon)list;
            List list4 = $colon$colon.next$access$1();
            Object h = $colon$colon.head();
            List tail = list4;
            Tuple2 tuple23 = this.splitRecursive(n3 - 1, tail);
            if (!(tuple23 instanceof Tuple2)) {
                throw new MatchError(tuple23);
            }
            Tuple2 tuple24 = tuple23;
            List pre = tuple24._1();
            List post = tuple24._2();
            Tuple2 tuple25 = Tuple2$.MODULE$.apply(pre, post);
            List pre2 = tuple25._1();
            List post2 = tuple25._2();
            tuple2 = Tuple2$.MODULE$.apply(pre2.$colon$colon(h), post2);
        }
        return tuple2;
    }

    public <A> Tuple2<List<A>, List<A>> splitTailRecursive(int n, List<A> ls) {
        return this.splitR$1(n, ls, package$.MODULE$.Nil());
    }

    public <A> Tuple2<List<A>, List<A>> splitFunctional(int n, List<A> ls) {
        return Tuple2$.MODULE$.apply(ls.take(n), ls.drop(n));
    }

    private final Tuple2 splitR$1(int curN, List curL, List pre) {
        Tuple2<Object, List> tuple2;
        block3: {
            Tuple2<Integer, List> tuple22;
            List list = pre;
            List list2 = curL;
            int n = curN;
            while ((tuple22 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n), list2)) != null) {
                int n2 = BoxesRunTime.unboxToInt(tuple22._1());
                List list3 = tuple22._2();
                Nil$ nil$ = package$.MODULE$.Nil();
                List list4 = list3;
                if (!(nil$ != null ? !((Object)nil$).equals(list4) : list4 != null)) {
                    tuple2 = Tuple2$.MODULE$.apply(list.reverse(), package$.MODULE$.Nil());
                    break block3;
                }
                if (0 == n2) {
                    List list5 = list3;
                    tuple2 = Tuple2$.MODULE$.apply(list.reverse(), list5);
                    break block3;
                }
                int n3 = n2;
                if (!(list3 instanceof $colon$colon)) break;
                $colon$colon $colon$colon = ($colon$colon)list3;
                List list6 = $colon$colon.next$access$1();
                Object h = $colon$colon.head();
                List tail = list6;
                int n4 = n3 - 1;
                List list7 = tail;
                List list8 = list.$colon$colon(h);
                n = n4;
                list2 = list7;
                list = list8;
            }
            throw new MatchError(tuple22);
        }
        return tuple2;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Tuple2;
import scala.collection.immutable.List;

public final class P17 {
    public static <A> Tuple2<List<A>, List<A>> splitBuiltin(int n, List<A> list) {
        return P17$.MODULE$.splitBuiltin(n, list);
    }

    public static <A> Tuple2<List<A>, List<A>> splitFunctional(int n, List<A> list) {
        return P17$.MODULE$.splitFunctional(n, list);
    }

    public static <A> Tuple2<List<A>, List<A>> splitRecursive(int n, List<A> list) {
        return P17$.MODULE$.splitRecursive(n, list);
    }

    public static <A> Tuple2<List<A>, List<A>> splitTailRecursive(int n, List<A> list) {
        return P17$.MODULE$.splitTailRecursive(n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Predef$;
import scala.Tuple2;
import scala.Tuple2$;
import scala.Tuple3;
import scala.Tuple3$;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.RichInt$;

public final class P18$
implements Serializable {
    public static final P18$ MODULE$;

    public static {
        new P18$();
    }

    private P18$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P18$.class);
    }

    public <A> List<A> sliceBuiltin(int start, int end, List<A> ls) {
        return ls.slice(start, end);
    }

    public <A> List<A> sliceRecursive(int start, int end, List<A> ls) {
        List list;
        block4: {
            Tuple3<Integer, Integer, List<A>> tuple3;
            List<A> list2 = ls;
            int n = end;
            int n2 = start;
            while ((tuple3 = Tuple3$.MODULE$.apply(BoxesRunTime.boxToInteger(n2), BoxesRunTime.boxToInteger(n), list2)) != null) {
                int n3 = BoxesRunTime.unboxToInt(tuple3._1());
                int n4 = BoxesRunTime.unboxToInt(tuple3._2());
                List<A> list3 = tuple3._3();
                Nil$ nil$ = package$.MODULE$.Nil();
                List<A> list4 = list3;
                if (!(nil$ != null ? !((Object)nil$).equals(list4) : list4 != null)) {
                    list = package$.MODULE$.Nil();
                    break block4;
                }
                int e = n4;
                if (e <= 0) {
                    list = package$.MODULE$.Nil();
                    break block4;
                }
                int s = n3;
                int e2 = n4;
                if (!(list3 instanceof $colon$colon)) break;
                $colon$colon $colon$colon = ($colon$colon)list3;
                Object a = $colon$colon.head();
                List list5 = $colon$colon.next$access$1();
                Object h = a;
                List tail = list5;
                if (s <= 0) {
                    list = this.sliceRecursive(0, e2 - 1, tail).$colon$colon(h);
                    break block4;
                }
                int s2 = n3;
                int e3 = n4;
                Object h2 = a;
                List tail2 = list5;
                int n5 = s2 - 1;
                int n6 = e3 - 1;
                List list6 = tail2;
                n2 = n5;
                n = n6;
                list2 = list6;
            }
            throw new MatchError(tuple3);
        }
        return list;
    }

    public <A> List<A> sliceTailRecursive(int start, int end, List<A> ls) {
        return this.sliceR$1(start, end, 0, ls, package$.MODULE$.Nil());
    }

    public <A> List<A> sliceTailRecursive2(int start, int end, List<A> ls) {
        return this.sliceR$2(start, end, 0, ls, package$.MODULE$.Nil());
    }

    public <A> List<A> sliceFunctional(int s, int e, List<A> ls) {
        return ((List)ls.drop(s)).take(e - RichInt$.MODULE$.max$extension(Predef$.MODULE$.intWrapper(s), 0));
    }

    private final List sliceR$1(int start$1, int end$1, int count, List curList, List result) {
        Object object;
        block4: {
            Tuple2<Integer, List> tuple2;
            List list = result;
            List list2 = curList;
            int n = count;
            while ((tuple2 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n), list2)) != null) {
                int n2 = BoxesRunTime.unboxToInt(tuple2._1());
                List list3 = tuple2._2();
                Nil$ nil$ = package$.MODULE$.Nil();
                List list4 = list3;
                if (!(nil$ != null ? !((Object)nil$).equals(list4) : list4 != null)) {
                    object = list.reverse();
                    break block4;
                }
                int c = n2;
                if (!(list3 instanceof $colon$colon)) break;
                $colon$colon $colon$colon = ($colon$colon)list3;
                Object a = $colon$colon.head();
                List list5 = $colon$colon.next$access$1();
                Object h = a;
                List tail = list5;
                if (end$1 <= c) {
                    object = list.reverse();
                    break block4;
                }
                int c2 = n2;
                Object h2 = a;
                List tail2 = list5;
                if (start$1 <= c2) {
                    int n3 = c2 + 1;
                    List list6 = tail2;
                    List list7 = list.$colon$colon(h2);
                    n = n3;
                    list2 = list6;
                    list = list7;
                    continue;
                }
                int c3 = n2;
                List tail3 = list5;
                int n4 = c3 + 1;
                List list8 = tail3;
                n = n4;
                list2 = list8;
            }
            throw new MatchError(tuple2);
        }
        return object;
    }

    private final List sliceR$2(int start$2, int end$2, int count, List curList, List result) {
        List list = result;
        List list2 = curList;
        int n = count;
        while (!list2.isEmpty() && n < end$2) {
            List list3;
            int n2 = n + 1;
            List list4 = (List)list2.tail();
            if (n >= start$2) {
                Object a = list2.head();
                list3 = list.$colon$colon(a);
            } else {
                list3 = list;
            }
            List list5 = list3;
            n = n2;
            list2 = list4;
            list = list5;
        }
        return list.reverse();
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P18 {
    public static <A> List<A> sliceBuiltin(int n, int n2, List<A> list) {
        return P18$.MODULE$.sliceBuiltin(n, n2, list);
    }

    public static <A> List<A> sliceFunctional(int n, int n2, List<A> list) {
        return P18$.MODULE$.sliceFunctional(n, n2, list);
    }

    public static <A> List<A> sliceRecursive(int n, int n2, List<A> list) {
        return P18$.MODULE$.sliceRecursive(n, n2, list);
    }

    public static <A> List<A> sliceTailRecursive(int n, int n2, List<A> list) {
        return P18$.MODULE$.sliceTailRecursive(n, n2, list);
    }

    public static <A> List<A> sliceTailRecursive2(int n, int n2, List<A> list) {
        return P18$.MODULE$.sliceTailRecursive2(n, n2, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.collection.immutable.List;
import scala.runtime.ModuleSerializationProxy;

public final class P19$
implements Serializable {
    public static final P19$ MODULE$;

    public static {
        new P19$();
    }

    private P19$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P19$.class);
    }

    public <A> List<A> rotate(int n, List<A> ls) {
        int nBounded;
        int n2 = n;
        while (true) {
            int n3 = nBounded = ls.isEmpty() ? 0 : n2 % ls.length();
            if (nBounded >= 0) break;
            n2 = nBounded + ls.length();
        }
        List list = (List)ls.drop(nBounded);
        return ((List)ls.take(nBounded)).$colon$colon$colon(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P19 {
    public static <A> List<A> rotate(int n, List<A> list) {
        return P19$.MODULE$.rotate(n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import java.util.NoSuchElementException;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P20$
implements Serializable {
    public static final P20$ MODULE$;

    public static {
        new P20$();
    }

    private P20$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P20$.class);
    }

    /*
     * Enabled force condition propagation
     * Lifted jumps to return sites
     */
    public <A> Tuple2<List<A>, A> removeAt(int n, List<A> ls) {
        Tuple2<List<A>, List<A>> tuple2 = ls.splitAt(n);
        if (tuple2 == null) throw new MatchError(tuple2);
        List<A> list = tuple2._1();
        List<A> list2 = tuple2._2();
        Nil$ nil$ = package$.MODULE$.Nil();
        List<A> list3 = list;
        if (!(nil$ != null ? !((Object)nil$).equals(list3) : list3 != null) && n < 0) {
            throw new NoSuchElementException();
        }
        List<A> pre = list;
        if (!(list2 instanceof $colon$colon)) {
            List<A> pre2 = list;
            Nil$ nil$2 = package$.MODULE$.Nil();
            List<A> list4 = list2;
            if (nil$2 != null ? !((Object)nil$2).equals(list4) : list4 != null) throw new MatchError(tuple2);
            throw new NoSuchElementException();
        }
        $colon$colon $colon$colon = ($colon$colon)list2;
        List list5 = $colon$colon.next$access$1();
        Object e = $colon$colon.head();
        List post = list5;
        return Tuple2$.MODULE$.apply(post.$colon$colon$colon(pre), e);
    }

    /*
     * Enabled force condition propagation
     * Lifted jumps to return sites
     */
    public <A> Tuple2<List<A>, A> removeAt2(int n, List<A> ls) {
        Tuple2 tuple2;
        if (n < 0) {
            throw new NoSuchElementException();
        }
        Tuple2<Integer, List<A>> tuple22 = Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n), ls);
        if (tuple22 == null) throw new MatchError(tuple22);
        List<A> list = tuple22._2();
        Nil$ nil$ = package$.MODULE$.Nil();
        List<A> list2 = list;
        if (!(nil$ != null ? !((Object)nil$).equals(list2) : list2 != null)) {
            throw new NoSuchElementException();
        }
        if (0 == BoxesRunTime.unboxToInt(tuple22._1()) && list instanceof $colon$colon) {
            $colon$colon $colon$colon = ($colon$colon)list;
            List list3 = $colon$colon.next$access$1();
            Object h = $colon$colon.head();
            List tail = list3;
            tuple2 = Tuple2$.MODULE$.apply(tail, h);
            return tuple2;
        } else {
            if (!(list instanceof $colon$colon)) throw new MatchError(tuple22);
            $colon$colon $colon$colon = ($colon$colon)list;
            List list4 = $colon$colon.next$access$1();
            Object h = $colon$colon.head();
            List tail = list4;
            Tuple2<List<A>, A> tuple23 = this.removeAt(n - 1, (List)ls.tail());
            if (!(tuple23 instanceof Tuple2)) {
                throw new MatchError(tuple23);
            }
            Tuple2<List<A>, A> tuple24 = tuple23;
            List<A> t = tuple24._1();
            A e = tuple24._2();
            Tuple2<List<A>, A> tuple25 = Tuple2$.MODULE$.apply(t, e);
            List<A> t2 = tuple25._1();
            A e2 = tuple25._2();
            Object a = ls.head();
            tuple2 = Tuple2$.MODULE$.apply(t2.$colon$colon(a), e2);
        }
        return tuple2;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Tuple2;
import scala.collection.immutable.List;

public final class P20 {
    public static <A> Tuple2<List<A>, A> removeAt(int n, List<A> list) {
        return P20$.MODULE$.removeAt(n, list);
    }

    public static <A> Tuple2<List<A>, A> removeAt2(int n, List<A> list) {
        return P20$.MODULE$.removeAt2(n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Tuple2;
import scala.collection.immutable.List;
import scala.runtime.ModuleSerializationProxy;

public final class P21$
implements Serializable {
    public static final P21$ MODULE$;

    public static {
        new P21$();
    }

    private P21$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P21$.class);
    }

    public <A> List<A> insertAt(A e, int n, List<A> ls) {
        Tuple2<List<A>, List<A>> tuple2 = ls.splitAt(n);
        if (tuple2 == null) {
            throw new MatchError(tuple2);
        }
        List<A> pre = tuple2._1();
        List<A> post = tuple2._2();
        return post.$colon$colon(e).$colon$colon$colon(pre);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P21 {
    public static <A> List<A> insertAt(A a, int n, List<A> list) {
        return P21$.MODULE$.insertAt(a, n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Function1;
import scala.MatchError;
import scala.None$;
import scala.Option;
import scala.Some;
import scala.Some$;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.List;
import scala.math.Integral;
import scala.math.Numeric;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P22$
implements Serializable {
    public static final P22$ MODULE$;

    public static {
        new P22$();
    }

    private P22$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P22$.class);
    }

    public List<Object> rangeBuiltin(int start, int end) {
        return (List)package$.MODULE$.List().range(BoxesRunTime.boxToInteger(start), BoxesRunTime.boxToInteger(end + 1), (Integral)Numeric.IntIsIntegral$.MODULE$);
    }

    public List<Object> rangeRecursive(int start, int end) {
        return end < start ? package$.MODULE$.Nil() : this.rangeRecursive(start + 1, end).$colon$colon(BoxesRunTime.boxToInteger(start));
    }

    public List<Object> rangeTailRecursive(int start, int end) {
        return this.rangeR$1(start, end, package$.MODULE$.Nil());
    }

    public <A, B> List<A> unfoldRight(B s, Function1<B, Option<Tuple2<A, B>>> f) {
        Tuple2 tuple2;
        List list;
        Option<Tuple2<A, B>> option = f.apply(s);
        if (None$.MODULE$.equals(option)) {
            list = package$.MODULE$.Nil();
        } else if (option instanceof Some && (tuple2 = (Tuple2)((Some)option).value()) != null) {
            Object r = tuple2._1();
            Object n = tuple2._2();
            list = this.unfoldRight(n, f).$colon$colon(r);
        } else {
            throw new MatchError(option);
        }
        return list;
    }

    public List<Object> rangeFunctional(int start, int end) {
        return this.unfoldRight(BoxesRunTime.boxToInteger(start), arg_0 -> this.rangeFunctional$$anonfun$adapted$1(end, arg_0));
    }

    private final List rangeR$1(int start$1, int end, List result) {
        List<Integer> list = result;
        int n = end;
        while (n >= start$1) {
            int n2 = n - 1;
            List<Integer> list2 = list.$colon$colon(BoxesRunTime.boxToInteger(n));
            n = n2;
            list = list2;
        }
        return list;
    }

    private final /* synthetic */ Option rangeFunctional$$anonfun$1(int end$1, int n) {
        return n > end$1 ? None$.MODULE$ : Some$.MODULE$.apply(Tuple2$.MODULE$.apply(BoxesRunTime.boxToInteger(n), BoxesRunTime.boxToInteger(n + 1)));
    }

    private final Option rangeFunctional$$anonfun$adapted$1(int end$2, Object n) {
        return this.rangeFunctional$$anonfun$1(end$2, BoxesRunTime.unboxToInt(n));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Function1;
import scala.Option;
import scala.Tuple2;
import scala.collection.immutable.List;

public final class P22 {
    public static List<Object> rangeBuiltin(int n, int n2) {
        return P22$.MODULE$.rangeBuiltin(n, n2);
    }

    public static List<Object> rangeFunctional(int n, int n2) {
        return P22$.MODULE$.rangeFunctional(n, n2);
    }

    public static List<Object> rangeRecursive(int n, int n2) {
        return P22$.MODULE$.rangeRecursive(n, n2);
    }

    public static List<Object> rangeTailRecursive(int n, int n2) {
        return P22$.MODULE$.rangeTailRecursive(n, n2);
    }

    public static <A, B> List<A> unfoldRight(B b, Function1<B, Option<Tuple2<A, B>>> function1) {
        return P22$.MODULE$.unfoldRight(b, function1);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.immutable.List;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;
import scala.util.Random;

public final class P23$
implements Serializable {
    public static final P23$ MODULE$;

    public static {
        new P23$();
    }

    private P23$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P23$.class);
    }

    public <A> List<A> randomSelect1(int n, List<A> ls) {
        List list;
        if (n <= 0) {
            list = package$.MODULE$.Nil();
        } else {
            Tuple2<List<A>, A> tuple2 = P20$.MODULE$.removeAt(new Random().nextInt(ls.length()), ls);
            if (!(tuple2 instanceof Tuple2)) {
                throw new MatchError(tuple2);
            }
            Tuple2<List<A>, A> tuple22 = tuple2;
            List<A> rest = tuple22._1();
            A e = tuple22._2();
            Tuple2<List<A>, A> tuple23 = Tuple2$.MODULE$.apply(rest, e);
            List<A> rest2 = tuple23._1();
            A e2 = tuple23._2();
            list = this.randomSelect1(n - 1, rest2).$colon$colon(e2);
        }
        return list;
    }

    public <A> List<A> randomSelect(int n, List<A> ls) {
        return this.randomSelectR$1(n, ls, new Random());
    }

    private final List randomSelectR$1(int n, List ls, Random r) {
        List list;
        if (n <= 0) {
            list = package$.MODULE$.Nil();
        } else {
            Tuple2 tuple2 = P20$.MODULE$.removeAt(r.nextInt(ls.length()), ls);
            if (!(tuple2 instanceof Tuple2)) {
                throw new MatchError(tuple2);
            }
            Tuple2 tuple22 = tuple2;
            List rest = tuple22._1();
            Object e = tuple22._2();
            Tuple2 tuple23 = Tuple2$.MODULE$.apply(rest, e);
            List rest2 = tuple23._1();
            Object e2 = tuple23._2();
            list = this.randomSelectR$1(n - 1, rest2, r).$colon$colon(e2);
        }
        return list;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P23 {
    public static <A> List<A> randomSelect(int n, List<A> list) {
        return P23$.MODULE$.randomSelect(n, list);
    }

    public static <A> List<A> randomSelect1(int n, List<A> list) {
        return P23$.MODULE$.randomSelect1(n, list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.collection.immutable.List;
import scala.math.Integral;
import scala.math.Numeric;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P24$
implements Serializable {
    public static final P24$ MODULE$;

    public static {
        new P24$();
    }

    private P24$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P24$.class);
    }

    public List<Object> lotto(int count, int max) {
        return P23$.MODULE$.randomSelect(count, (List)package$.MODULE$.List().range(BoxesRunTime.boxToInteger(1), BoxesRunTime.boxToInteger(max + 1), (Integral)Numeric.IntIsIntegral$.MODULE$));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P24 {
    public static List<Object> lotto(int n, int n2) {
        return P24$.MODULE$.lotto(n, n2);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Predef$;
import scala.collection.immutable.List;
import scala.reflect.Manifest;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.RichInt$;
import scala.runtime.ScalaRunTime$;
import scala.util.Random;

public final class P25$
implements Serializable {
    public static final P25$ MODULE$;

    public static {
        new P25$();
    }

    private P25$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P25$.class);
    }

    public <A> List<A> randomPermute1(List<A> ls) {
        return P23$.MODULE$.randomSelect(ls.length(), ls);
    }

    public <A> List<A> randomPermute(List<A> ls, Manifest<A> m) {
        Random rand = new Random();
        Object a = ls.toArray(m);
        RichInt$.MODULE$.to$extension(Predef$.MODULE$.intWrapper(ScalaRunTime$.MODULE$.array_length(a) - 1), 1).by(-1).foreach(i -> {
            int i1 = rand.nextInt(i + 1);
            Object t = ScalaRunTime$.MODULE$.array_apply(a, i);
            ScalaRunTime$.MODULE$.array_update(a, i, ScalaRunTime$.MODULE$.array_apply(a, i1));
            ScalaRunTime$.MODULE$.array_update(a, i1, t);
        });
        return Predef$.MODULE$.genericWrapArray(a).toList();
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;
import scala.reflect.Manifest;

public final class P25 {
    public static <A> List<A> randomPermute(List<A> list, Manifest<A> manifest) {
        return P25$.MODULE$.randomPermute(list, manifest);
    }

    public static <A> List<A> randomPermute1(List<A> list) {
        return P25$.MODULE$.randomPermute1(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Function1;
import scala.MatchError;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.collection.immutable.Seq;
import scala.package$;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.ScalaRunTime$;

public final class P26$
implements Serializable {
    public static final P26$ MODULE$;

    public static {
        new P26$();
    }

    private P26$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P26$.class);
    }

    public <A, B> List<B> flatMapSublists(List<A> ls, Function1<List<A>, List<B>> f) {
        List list;
        List<A> list2 = ls;
        Nil$ nil$ = package$.MODULE$.Nil();
        List<A> list3 = list2;
        if (!(nil$ != null ? !((Object)nil$).equals(list3) : list3 != null)) {
            list = package$.MODULE$.Nil();
        } else if (list2 instanceof $colon$colon) {
            List list4;
            $colon$colon $colon$colon = ($colon$colon)list2;
            List tail = list4 = $colon$colon.next$access$1();
            $colon$colon sublist = $colon$colon;
            List<B> list5 = f.apply(sublist);
            list = this.flatMapSublists(tail, f).$colon$colon$colon(list5);
        } else {
            throw new MatchError(list2);
        }
        return list;
    }

    public <A> List<List<A>> combinations(int n, List<A> ls) {
        return n == 0 ? (List)package$.MODULE$.List().apply((Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Nil$[]{package$.MODULE$.Nil()})) : this.flatMapSublists(ls, sl -> this.combinations(n - 1, (List)sl.tail()).map(_$1 -> {
            Object a = sl.head();
            return _$1.$colon$colon(a);
        }));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.Function1;
import scala.collection.immutable.List;

public final class P26 {
    public static <A> List<List<A>> combinations(int n, List<A> list) {
        return P26$.MODULE$.combinations(n, list);
    }

    public static <A, B> List<B> flatMapSublists(List<A> list, Function1<List<A>, List<B>> function1) {
        return P26$.MODULE$.flatMapSublists(list, function1);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.MatchError;
import scala.Tuple2;
import scala.Tuple2$;
import scala.collection.Seq;
import scala.collection.immutable.$colon$colon;
import scala.collection.immutable.List;
import scala.collection.immutable.Nil$;
import scala.package$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;
import scala.runtime.ScalaRunTime$;

public final class P27$
implements Serializable {
    public static final P27$ MODULE$;

    public static {
        new P27$();
    }

    private P27$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P27$.class);
    }

    public <A> List<List<List<A>>> group3(List<A> ls) {
        return ((List)P26$.MODULE$.combinations(2, ls).map(a -> {
            List noA = (List)ls.diff((Seq)package$.MODULE$.List().apply((scala.collection.immutable.Seq)ScalaRunTime$.MODULE$.wrapRefArray(new List[]{a})));
            return Tuple2$.MODULE$.apply(a, noA);
        })).flatMap(x$1 -> {
            Tuple2 tuple2 = x$1;
            if (tuple2 == null) {
                throw new MatchError(tuple2);
            }
            List a = (List)tuple2._1();
            List noA = (List)tuple2._2();
            return P26$.MODULE$.combinations(3, noA).map(b -> (List)package$.MODULE$.List().apply((scala.collection.immutable.Seq)ScalaRunTime$.MODULE$.wrapRefArray(new List[]{a, b, (List)noA.diff((Seq)package$.MODULE$.List().apply((scala.collection.immutable.Seq)ScalaRunTime$.MODULE$.wrapRefArray(new List[]{b})))})));
        });
    }

    public <A> List<List<List<A>>> group(List<Object> ns, List<A> ls) {
        Object object;
        List<Object> list = ns;
        Nil$ nil$ = package$.MODULE$.Nil();
        List<Object> list2 = list;
        if (!(nil$ != null ? !((Object)nil$).equals(list2) : list2 != null)) {
            object = (List)package$.MODULE$.List().apply((scala.collection.immutable.Seq)ScalaRunTime$.MODULE$.genericWrapArray(new Nil$[]{package$.MODULE$.Nil()}));
        } else if (list instanceof $colon$colon) {
            $colon$colon $colon$colon = ($colon$colon)list;
            List list3 = $colon$colon.next$access$1();
            int n = BoxesRunTime.unboxToInt($colon$colon.head());
            List ns2 = list3;
            object = P26$.MODULE$.combinations(n, ls).flatMap(c -> this.group(ns2, (List)ls.diff((Seq)package$.MODULE$.List().apply((scala.collection.immutable.Seq)ScalaRunTime$.MODULE$.wrapRefArray(new List[]{c})))).map(_$1 -> _$1.$colon$colon(c)));
        } else {
            throw new MatchError(list);
        }
        return object;
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P27 {
    public static <A> List<List<List<A>>> group(List<Object> list, List<A> list2) {
        return P27$.MODULE$.group(list, list2);
    }

    public static <A> List<List<List<A>>> group3(List<A> list) {
        return P27$.MODULE$.group3(list);
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Predef$;
import scala.collection.AbstractSeq;
import scala.collection.immutable.List;
import scala.collection.immutable.Map;
import scala.collection.immutable.Seq;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class P28$
implements Serializable {
    public static final P28$ MODULE$;

    public static {
        new P28$();
    }

    private P28$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(P28$.class);
    }

    public <A> List<List<A>> lsort(List<List<A>> ls) {
        return (List)ls.sortWith((_$1, _$2) -> _$1.length() < _$2.length());
    }

    public <A> List<List<A>> lsortFreq(List<List<A>> ls) {
        Map freqs = (Map)Predef$.MODULE$.Map().apply((Seq)P10$.MODULE$.encode((List)((AbstractSeq)ls.map(_$3 -> _$3.length())).sortWith((_$4, _$5) -> _$4 < _$5)).map(_$6 -> _$6.swap()));
        return (List)ls.sortWith((e1, e2) -> BoxesRunTime.unboxToInt(freqs.apply(BoxesRunTime.boxToInteger(e1.length()))) < BoxesRunTime.unboxToInt(freqs.apply(BoxesRunTime.boxToInteger(e2.length()))));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
import scala.collection.immutable.List;

public final class P28 {
    public static <A> List<List<A>> lsort(List<List<A>> list) {
        return P28$.MODULE$.lsort(list);
    }

    public static <A> List<List<A>> lsortFreq(List<List<A>> list) {
        return P28$.MODULE$.lsortFreq(list);
    }
}
