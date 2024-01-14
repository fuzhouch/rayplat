package("libglvnd")

    set_homepage("https://gitlab.freedesktop.org/glvnd/libglvnd")
    set_description("libglvnd: the GL Vendor-Neutral Dispatch library")

    add_urls("https://gitlab.freedesktop.org/glvnd/libglvnd/-/archive/$(version)/libglvnd-$(version).tar.gz",
             "https://gitlab.freedesktop.org/glvnd/libglvnd.git")
    add_versions("v1.3.4", "c42061da999f75234f9bca501c21144d9a5768c5911d674eceb8650ce3fb94bb")
    add_versions("v1.7.0", "2b6e15b06aafb4c0b6e2348124808cbd9b291c647299eaaba2e3202f51ff2f3d")

    add_configs("shared", {description = "Build shared library.", default = true, type = "boolean", readonly = true})

    if is_plat("linux") then
        add_extsources("apt::libglvnd-dev", "pacman::libglvnd")
    end

    add_deps("meson", "ninja", "pkg-config")
    on_install("linux", function (package)
        print(package:sourcehash(package:url_alias(package:urls()[1])))
        import("package.tools.meson").install(package)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("glInitNames", {includes = "GL/gl.h"}))
    end)
