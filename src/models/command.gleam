import birl.{type Time}

pub type Command(command_data) {
  Command(issued_at: Time, issuer: String, data: command_data)
}

pub fn create(data: command_data, issuer: String) {
  Command(issued_at: birl.now(), data: data, issuer: issuer)
}
