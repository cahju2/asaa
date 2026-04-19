pub fn verify_login(password: &str) -> bool {
    // 実際の運用ではLinuxのPAMを通すなどの処理を行いますが、
    // ここでは安全なデモ用パスワードをハードコードしています。
    match password {
        "nimbus100" | "admin" => true,
        _ => false,
    }
}
