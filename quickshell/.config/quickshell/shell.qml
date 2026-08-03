//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import "bar"
import "components"
import "powermenu"

Scope {
    Bar {}
    PowerMenu {}

    IpcHandler {
        target: "powermenu"

        function toggle(): void {
            PowerMenuState.toggle();
        }

        function show(): void {
            PowerMenuState.open = true;
        }

        function close(): void {
            PowerMenuState.close();
        }
    }
}
