use std::sync::{Arc, Mutex};
use sysinfo::System;
use tokio::time::{sleep, Duration};
use slint::Weak;
use crate::NimbusShell;

pub fn start_monitoring(ui_handle: Weak<NimbusShell>) {
    let sys = Arc::new(Mutex::new(System::new_all()));
    let update_sys = sys.clone();
    
    tokio::spawn(async move {
        loop {
            let now = chrono::Local::now();
            let time_str = now.format("%H:%M").to_string();
            let date_str = now.format("%a, %b %e").to_string();

            let mut s = update_sys.lock().unwrap();
            s.refresh_cpu_usage();
            s.refresh_memory();
            let cpu = s.global_cpu_info().cpu_usage();
            let ram_used = s.used_memory() as f64;
            let ram_total = s.total_memory() as f64;
            let ram_percent = if ram_total > 1.0 { (ram_used / ram_total) * 100.0 } else { 0.0 };

            let _ = ui_handle.upgrade_in_event_loop(move |ui| {
                ui.set_clock_time(time_str.into());
                ui.set_clock_date(date_str.into());
                ui.set_cpu_usage(cpu);
                ui.set_ram_usage(ram_percent as f32);
            });
            
            sleep(Duration::from_millis(1000)).await;
        }
    });
}
