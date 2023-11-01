
# https://bazel.build/reference/be/java
java_binary(
    name = "helloworld",
    srcs = glob(["src/main/scala/**/*.scala"]),
    resources = glob(["src/main/resources/**"]),
    deps = ["//:all-external-targets"],
    main_class = "Main"
  )