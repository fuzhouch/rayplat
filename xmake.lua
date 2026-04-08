add_rules("mode.debug", "mode.release")
set_languages("c99", "c++20")
add_repositories("local-repo deps")
add_requires("raylib-minimal 5.5", {alias = "raylib", system = false, configs = { wayland=true, x11=true }})

function copy_executable_to_lib(target)
    -- This step is required for Linux to ensure executable
    -- and dependencies (OpenGL, mostly) are put under same folder.
    -- We can launch executable from lib/ folder.
    if is_plat("linux") then
        local bin_from = path.join(target:installdir(), "bin", target:filename())
        local bin_install = path.join(target:installdir(), "lib", target:filename())
        print("[after install] copy " .. target:filename() .. " to " .. bin_install)
        os.cp(bin_from, bin_install)
    end
end

function binary_link_flags(target)
    -- Use static linking to ensure the binaries can be distributed
    -- across different distros without breaking.
    if target:is_plat("linux") then
        target:add("rpathdirs", "$ORIGIN")
        target:add("ldflags", "-Wl,--no-undefined")
        target:add("ldflags", "-static-libgcc")
        target:add("ldflags", "-static-libstdc++")
    end
end


target("rayplat")
    set_kind("binary")
    add_files("src/*.cpp", "src/*.c")
    set_symbols("debug")
    add_packages("raylib")
    on_load(binary_link_flags)
    -- Copy raylib DLLs/shared libs to the binary directory
    after_build(function (target)
        if is_plat("windows", "mingw") then
             local libfiles = {}
             for _, pkg in pairs(target:pkgs()) do
                local pkg_installdir = pkg:installdir()
                if pkg_installdir then
                    local dllfiles = os.files(path.join(pkg_installdir, "bin", "*"))
                    for _, dllfile in pairs(dllfiles) do
                        os.cp(dllfile, target:targetdir())
                    end
                    local pdbfiles = os.files(path.join(pkg_installdir, "lib", "*.pdb"))
                    for _, pdbfile in pairs(pdbfiles) do
                        os.cp(pdbfile, target:targetdir())
                    end
                end
            end
        end
    end)
    after_install(copy_executable_to_lib)
