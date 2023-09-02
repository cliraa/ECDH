extern crate k256;
extern crate p256;

use k256::{EncodedPoint, PublicKey, ecdh::EphemeralSecret};
use k256::elliptic_curve::rand_core::OsRng;
fn main() {

let a = EphemeralSecret::random(&mut OsRng);
let aa = EncodedPoint::from(a.public_key());

let b = EphemeralSecret::random(&mut OsRng);
let bb = EncodedPoint::from(b.public_key());

let bob_public = PublicKey::from_sec1_bytes(bb.as_ref()).expect("Bob's public key invalid");
let alice_public = PublicKey::from_sec1_bytes(aa.as_ref()).expect("Alice's public key invalid");

let abytes= aa.as_ref();
println!("\nAlice Public Key: {:x?}",hex::encode(abytes));

let bbytes= bb.as_ref();
println!("\nBob Public Key: {:x?}",hex::encode(bbytes));

let alice_shared = a.diffie_hellman(&bob_public);
let bob_shared = b.diffie_hellman(&alice_public);

let shared1= alice_shared.raw_secret_bytes();
println!("\nAlice Shared Key: {:x?}",hex::encode(shared1));

let shared2= bob_shared.raw_secret_bytes();
println!("\nBob Shared Key: {:x?}",hex::encode(shared2));

if alice_shared.raw_secret_bytes()==bob_shared.raw_secret_bytes(){
  println!("\nVerified!")
}

}
