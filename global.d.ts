import "@girs/adw-1/ambient";
import "@girs/gdk-4.0/ambient";
import "@girs/gjs/ambient";
import "@girs/gjs/dom";
import "@girs/gjs";
import "@girs/glib-2.0/ambient";
import "@girs/gnome-shell/ambient";
import "@girs/gobject-2.0/ambient";
import "@girs/gtk-4.0/ambient";
import "@girs/st-18/ambient";
import "@girs/shell-18/ambient";
import "@girs/clutter-18/ambient";
import "@girs/pango-1.0/ambient";
import "@girs/soup-3.0/ambient";
import "@girs/meta-18/ambient";
import "@girs/cogl-2.0/ambient";
import "@girs/gdkpixbuf-2.0/ambient";

declare global {
    var global: any;

    interface ImportMeta {
        url: string;
    }

    interface String {
        format(...args: unknown[]): string;
    }
}

declare module "@girs/gobject-2.0" {
    namespace GObject {
        function type_from_name(name: string | null): GType | 0;
    }
}
