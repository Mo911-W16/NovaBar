/**
 * NovaOS Panel - Application entry point
 */

public class NovaApp : Gtk.Application {
    
    public NovaApp() {
        Object(application_id: "org.novaos.panel", flags: ApplicationFlags.FLAGS_NONE);
    }
    
    protected override void activate() {
        Settings.load_saved_theme();
        var panel = new NovaPanel(this);
        panel.show();
    }
    
    public static int main(string[] args) {
        var app = new NovaApp();
        return app.run(args);
    }
}
