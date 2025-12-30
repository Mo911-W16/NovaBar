/**
 * NovaOS Panel - Main panel window
 */

public class NovaPanel : Gtk.Window {
    private Gtk.Box container;
    private Gtk.Box left_box;
    private Gtk.Box center_box;
    private Gtk.Box right_box;
    private LogoMenu.NovaMenu logo_menu;
    
    public NovaPanel(Gtk.Application app) {
        Object(application: app);
        
        set_decorated(false);
        set_skip_taskbar_hint(true);
        set_skip_pager_hint(true);
        set_type_hint(Gdk.WindowTypeHint.DOCK);
        set_keep_above(true);
        stick();
        
        setup_geometry();
        setup_layout();
        load_css();
        
        show_all();
    }
    
    private void setup_geometry() {
        var display = Gdk.Display.get_default();
        var monitor = display.get_primary_monitor() ?? display.get_monitor(0);
        var geom = monitor.get_geometry();
        
        set_default_size(geom.width, 28);
        move(geom.x, geom.y);
        
        realize.connect(() => reserve_strut(geom));
    }
    
    private void reserve_strut(Gdk.Rectangle geom) {
        var window = get_window();
        if (window == null) return;
        
        var xwin = (Gdk.X11.Window)window;
        unowned X.Display xdisplay = ((Gdk.X11.Display)get_display()).get_xdisplay();
        var xid = xwin.get_xid();
        
        long strut[12] = { 0, 0, 28, 0, 0, 0, 0, 0, geom.x, geom.x + geom.width - 1, 0, 0 };
        var atom = xdisplay.intern_atom("_NET_WM_STRUT_PARTIAL", false);
        xdisplay.change_property((X.Window)xid, atom, X.XA_CARDINAL, 32, X.PropMode.Replace, (uchar[])strut, 12);
    }
    
    private void setup_layout() {
        // Enable right-click
        add_events(Gdk.EventMask.BUTTON_PRESS_MASK);
        button_press_event.connect((e) => {
            if (e.button == 3) {
                show_context_menu(e);
                return true;
            }
            return false;
        });
        
        container = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        container.get_style_context().add_class("panel-container");
        
        left_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4);
        left_box.margin_start = 8;
        
        center_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
        center_box.hexpand = true;
        center_box.halign = Gtk.Align.START;
        
        right_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 4);
        right_box.margin_end = 8;
        
        // Left: Logo menu
        logo_menu = new LogoMenu.NovaMenu();
        left_box.pack_start(logo_menu, false, false, 0);
        
        // Center: Global menu
        var menubar = new GlobalMenu.MenuBar();
        center_box.pack_start(menubar, false, false, 0);
        
        // Right: Indicators
        right_box.pack_end(new Indicators.DateTime(), false, false, 0);
        right_box.pack_end(new Indicators.ControlCenter(), false, false, 0);
        right_box.pack_end(new Indicators.Notifications(), false, false, 0);
        right_box.pack_end(new Indicators.Battery(), false, false, 0);
        right_box.pack_end(new Indicators.Sound(), false, false, 0);
        right_box.pack_end(new Indicators.Bluetooth(), false, false, 0);
        right_box.pack_end(new Indicators.Network(), false, false, 0);
        
        container.pack_start(left_box, false, false, 0);
        container.pack_start(center_box, true, true, 0);
        container.pack_end(right_box, false, false, 0);
        
        add(container);
        
        // Set panel window for global menu after realize
        realize.connect(() => menubar.set_panel_window(this));
    }
    
    private void show_context_menu(Gdk.EventButton e) {
        var menu = new Gtk.Menu();
        
        var settings_item = new Gtk.MenuItem.with_label("NovaBar Settings...");
        settings_item.activate.connect(() => {
            var win = new Settings.SettingsWindow();
            win.logo_icon_changed.connect((icon) => logo_menu.set_icon(icon));
            win.show_all();
        });
        menu.append(settings_item);
        
        menu.show_all();
        menu.popup_at_pointer(e);
    }
    
    private void load_css() {
        // CSS is now loaded by Settings.load_saved_theme()
    }
}
