// Compiled with scala3_0.25.0-RC2 
/*
 * Decompiled with CFR 0.150.
 */
import java.io.Serializable;
import scala.Predef$;
import scala.collection.StringOps$;
import scala.runtime.BoxesRunTime;
import scala.runtime.ModuleSerializationProxy;

public final class MultiplyOneTest$
implements Serializable {
    public static final MultiplyOneTest$ MODULE$;

    public static {
        new MultiplyOneTest$();
    }

    private MultiplyOneTest$() {
        MODULE$ = this;
    }

    private Object writeReplace() {
        return new ModuleSerializationProxy(MultiplyOneTest$.class);
    }

    public int twice(int x) {
        return x * x;
    }

    public void main(String[] args) {
        int a = 5;
        Predef$.MODULE$.println(BoxesRunTime.boxToInteger(a));
        Predef$.MODULE$.println(BoxesRunTime.boxToInteger(a));
        Predef$.MODULE$.println(BoxesRunTime.boxToInteger(this.twice(a)));
        Predef$.MODULE$.println(BoxesRunTime.boxToInteger(this.twice(a)));
        Predef$.MODULE$.println(BoxesRunTime.boxToDouble(Math.sqrt(2.0)));
        Predef$.MODULE$.println(BoxesRunTime.boxToDouble(Math.sqrt(2.0)));
        Predef$.MODULE$.println(StringOps$.MODULE$.$times$extension(Predef$.MODULE$.augmentString("a"), 1));
        Predef$.MODULE$.println(StringOps$.MODULE$.$times$extension(Predef$.MODULE$.augmentString("a"), 10));
    }
}
/*
 * Decompiled with CFR 0.150.
 */
public final class MultiplyOneTest {
    public static void main(String[] arrstring) {
        MultiplyOneTest$.MODULE$.main(arrstring);
    }

    public static int twice(int n) {
        return MultiplyOneTest$.MODULE$.twice(n);
    }
}
