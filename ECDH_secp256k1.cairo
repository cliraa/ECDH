// Elliptic Curve Diffie-Hellman (ECDH) implemented over the secp256k1 curve.

use option::OptionTrait;
use starknet::secp256k1::{secp256k1_new_syscall, Secp256k1Point};
use starknet::secp256_trait::{Secp256Trait, Secp256PointTrait};
use starknet::{SyscallResult, SyscallResultTrait};
use debug::PrintTrait;

// Generator Point:

fn get_generator_point() -> Secp256k1Point {
    secp256k1_new_syscall(
        0x79be667ef9dcbbac55a06295ce870b07029bfcdb2dce28d959f2815b16f81798,
        0x483ada7726a3c4655da4fbfc0e1108a8fd17b448a68554199c47d08ffb10d4b8
    )
        .unwrap_syscall()
        .unwrap()
}

// Private Keys:

fn Alice_PrivKey() -> u256 {
    0x2
}

fn Bob_PrivKey() -> u256 {
    0x3
}

#[test]
#[available_gas(1000000000)]
fn ECDH() {

    // Generator:

    let (Gx, Gy) = get_generator_point().get_coordinates().unwrap_syscall();

    // Privates Keys:

    let Alice_PrivKey = Alice_PrivKey();
    let Bob_PrivKey  = Bob_PrivKey();

    //Public Keys:

    let gx_gy = secp256k1_new_syscall(Gx,Gy).unwrap_syscall().unwrap();

    let Alice_PublicKey = gx_gy.mul(Alice_PrivKey).unwrap_syscall();
    let Bob_PublicKey = gx_gy.mul(Bob_PrivKey).unwrap_syscall();

    // Secret key:

    let coord_1 = Bob_PublicKey.mul(Alice_PrivKey).unwrap_syscall();
    let coord_2 = Alice_PublicKey.mul(Bob_PrivKey).unwrap_syscall();

    let (x, y) = coord_1.get_coordinates().unwrap_syscall();
    let (x2, y2) = coord_2.get_coordinates().unwrap_syscall();
    
    if x != x2 || y != y2 {
        panic_with_felt252('error')
    }

    let secret_key = x;

    'Secret Key:'.print();
    x.print();

}
