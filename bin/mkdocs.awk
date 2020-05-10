BEGIN {
    if (DEBUG) print "BEGIN";
    PRINT = 1;
    output_file = "";
}

{
    if (PRINT) {
        input_file = FILENAME;
        output_file = FILENAME".tmp";
        parent_dir = FILENAME;
        sub(/\\[A-Za-z0-9$-.]*.html$/, "", parent_dir);
        if (DEBUG) {
            print "File name : "FILENAME;
            print "Parent dir: "parent_dir;
        }
        n = 0;
        while (match(parent_dir, /\\[A-Za-z0-9$-.]*$/)) {
            ++n;
            parent_dir = substr(parent_dir, 0, length(parent_dir)-RLENGTH);
            # print "xxx: "parent_dir
        }
        if (DEBUG) print "n: "n;
        prefix = "";
        i = n; while (i > 0) { prefix = "../"prefix; --i }
        PRINT = 0;
    }
}

/href="\/api\// {
    if (DEBUG) print "Line     : "$0;
    sub(/href="\/api\//, "href=\""prefix"api/");
    if (DEBUG) print "Line("n") : "$0;
    print $0 > output_file;
    next;
}

/href="\/blog\// {
    if (DEBUG) print "Line     : "$0;
    sub(/href="\/blog\//, "href=\""prefix"blog/");
    if (DEBUG) print "Line("n") : "$0;
    print $0 > output_file;
    next;
}

/href="\/css\// {
    if (DEBUG) print "Line     : "$0;
    sub(/href="\/css\//, "href=\""prefix"css/");
    if (DEBUG) print "Line("n") : "$0;
    print $0 > output_file;
    next;
}

/href="\/docs\// {
    if (DEBUG) print "Line    : "$0;
    sub(/href="\/docs\//, "href=\""prefix"docs/");
    if (DEBUG) print "Line("n") : "$0;
    print $0 > output_file;
    next;
}

/href="\/images\// {
    if (DEBUG) print "Line    : "$0;
    sub(/href="\/images\//, "href=\""prefix"images/");
    if (DEBUG) print "Line("n") : "$0;
    print $0 > output_file;
    next;
}

/href="https:\/\/dotty.epfl.ch\/docs\// {
    if (DEBUG) print "Line       : "$0;
    sub(/href="https:\/\/dotty.epfl.ch\/docs\//, "href=\"./");
    if (DEBUG) print "Line(https): "$0;
    print $0 > output_file;
    next;
}

/src="\/images\// {
    if (DEBUG) print "Line     : "$0;
    sub(/src="\/images\//, "src=\""prefix"images/");
    if (DEBUG) print "Line("n") : "$0;
    print $0 > output_file;
    next;
}

/src="\/js\// {
    if (DEBUG) print "Line     : "$0;
    sub(/src="\/js\//, "src=\""prefix"js/");
    if (DEBUG) print "Line("n") : "$0;
    print $0 > output_file;
    next;
}

{
    print $0 > output_file;
}

END {
    if (DEBUG) print "END";
}
