import ids/uuid

pub fn new() {
  let assert Ok(id) = uuid.generate_v4()
  id
}
