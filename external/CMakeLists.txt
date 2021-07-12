add_library(quirc STATIC
    quirc/lib/decode.c
    quirc/lib/identify.c
    quirc/lib/quirk.c
    quirc/lib/version_db.c
)
target_include_directories(quirc PUBLIC quirc/lib)
