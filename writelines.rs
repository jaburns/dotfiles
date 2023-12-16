use std::error::Error;
use std::fs::{self, OpenOptions};
use std::io::prelude::*;
use std::io::{self, BufRead};

fn main() -> Result<(), Box<dyn Error>> {
    let stdin = io::stdin();
    let mut current_filename = String::new();
    let mut lines: Vec<String> = Vec::new();

    for line in stdin.lock().lines() {
        let line = line?;
        let parts: Vec<&str> = line.splitn(3, ':').collect();
        if parts.len() != 3 {
            return Err("Invalid format".into());
        }

        let filename = parts[0];

        if current_filename != filename {
            if !current_filename.is_empty() {
                save_file(&current_filename, &lines)?;
            }
            current_filename = filename.to_string();
            lines = fs::read_to_string(&current_filename)?
                .lines()
                .map(String::from)
                .collect();
        }

        let line_number: usize = parts[1].parse()?;
        if line_number == 0 || line_number > lines.len() + 1 {
            return Err("Line number out of bounds".into());
        }

        lines[line_number - 1] = parts[2].to_string();
    }

    if !current_filename.is_empty() {
        save_file(&current_filename, &lines)?;
    }

    Ok(())
}

fn save_file(filename: &str, lines: &[String]) -> Result<(), Box<dyn Error>> {
    let new_content = lines.join("\n");
    let mut file = OpenOptions::new()
        .write(true)
        .truncate(true)
        .open(filename)?;
    file.write_all(new_content.as_bytes())?;
    Ok(())
}
