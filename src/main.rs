mod auth;
mod sys_monitor;

slint::include_modules!();
use std::process::Command;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let ui = NimbusShell::new()?;
    let ui_handle = ui.as_weak();

    // Setup Auth Callbacks
    ui.on_login({
        let ui_handle = ui_handle.clone();
        move |password| {
            if let Some(ui) = ui_handle.upgrade() {
                let success = auth::verify_login(password.as_str());
                ui.set_is_logged_in(success);
                ui.set_auth_failed(!success);
            }
        }
    });

    ui.on_launch_app(|app| {
        let cmd = match app.as_str() {
            "terminal" => "xterm",
            "files" => "pcmanfm",
            "browser" => "firefox-esr",
            _ => return,
        };
        println!("[Nimbus Shell] Launching app: {}", cmd);
        match Command::new(cmd).spawn() {
            Ok(child) => println!("[Nimbus Shell] Successfully spawned {} with PID: {}", cmd, child.id()),
            Err(e) => eprintln!("[Nimbus Shell] Failed to spawn {}: {}", cmd, e),
        }
    });

    // System Power Management
    ui.on_system_action(|action| {
        println!("[Nimbus Shell] System state change requested: {}", action);
        let arg = match action.as_str() {
            "sleep" => "suspend",
            "reboot" => "reboot",
            "poweroff" => "poweroff",
            _ => return,
        };
        let _ = Command::new("systemctl").arg(arg).spawn();
    });

    // Spawning Background Worker for SysInfo
    sys_monitor::start_monitoring(ui_handle.clone());

    println!("[Nimbus Shell] Starting Level 100 UI Engine...");
    ui.run()?;
    Ok(())
}
