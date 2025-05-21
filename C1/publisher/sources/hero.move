module publisher::hero {
    use std::string::String;
    use sui::package::{Self, Publisher};

    const EWrongPublisher: u64 = 1;

    public struct Hero has key, store {
        id: UID,
        name: String,
    }

    public struct HERO has drop {} //one time witness, same name as module in uppercase

    fun init(otw: HERO, ctx: &mut TxContext) {
        // create Publisher and transfer it to the publisher wallet
        // let publisher = package::claim(otw, ctx);
        // transfer::public_transfer(publisher, recipient)
        package::claim_and_keep(otw, ctx);
    }

    public fun create_hero(publisher: &Publisher, name: String, ctx: &mut TxContext): Hero {
        // verify that publisher is from the same module
       assert!(publisher.from_module<HERO>(), EWrongPublisher);

        // create Hero resource
        let hero = Hero {
            id: object::new(ctx),
            name,
        };

        hero
    }

    public fun transfer_hero(publisher: &Publisher, hero: Hero, to: address) {
        // verify that publisher is from the same module
        assert!(publisher.from_module<HERO>(), EWrongPublisher);
        // transfer the Hero resource to the user
        // transfer::public_transfer(hero, to);
        transfer::transfer(hero, to);
    }

    // ===== TEST ONLY =====

    #[test_only]
    // use sui::package;
    use sui::transfer::public_transfer;
    use sui::transfer;
    use sui::{test_scenario as ts, test_utils::{assert_eq, destroy}};

    #[test_only]
    const ADMIN: address = @0xAA;
    #[test_only]
    const USER: address = @0xCC;

    #[test]
    fun test_publisher_address_gets_publihser_object() {
        let mut ts = ts::begin(ADMIN);

        assert_eq(ts::has_most_recent_for_address<Publisher>(ADMIN), false);

        init(HERO {}, ts.ctx());

        ts.next_tx(ADMIN);

        let publisher = ts.take_from_sender<Publisher>();
        assert_eq(publisher.from_module<HERO>(), true);
        ts.return_to_sender(publisher);

        ts.end();
    }

    #[test]
    fun test_admin_can_create_hero() {
        let mut ts = ts::begin(ADMIN);

        init(HERO {}, ts.ctx());

        ts.next_tx(ADMIN);

        let publisher = ts.take_from_sender<Publisher>();

        let hero = create_hero(&publisher, b"Hero 1".to_string(), ts.ctx());

        assert_eq(hero.name, b"Hero 1".to_string());

        ts.return_to_sender(publisher);

        destroy(hero);

        ts.end();
    }

    #[test]
    fun test_admin_can_transfer_hero() {
        let mut ts = ts::begin(ADMIN);

        init(HERO {}, ts.ctx());
        ts.next_tx(ADMIN);
        assert_eq(ts::has_most_recent_for_address<Publisher>(USER), false);

        let publisher = ts.take_from_sender<Publisher>();
        let hero = create_hero(&publisher, b"Hero 1".to_string(), ts.ctx());
        transfer_hero(&publisher, hero, USER);

        ts.next_tx(ADMIN);

        assert_eq(ts::has_most_recent_for_address<Hero>(USER), true);
        
        ts.return_to_sender(publisher);
        ts.end();
    }

    #[test_only]
    public struct HERO_TEST has drop {}

    #[test, expected_failure(abort_code = hero::EWrongPublisher)]
    fun test_publisher_cannot_mint_hero_with_wrong_publisher_object() {
        let test_otw = create_one_time_witness<HERO_TEST>();
        let ctx = tx_context::dummy();
        let publisher = package::test_claim(test_otw, &mut ctx);
        let hero = create_hero(&publisher, b"Hero 1".to_string(), ctx);

        destroy(hero);
        destroy(publisher);
    }
}

#[test_only]
module publisher::hero_test {
    use publisher::hero;
    use sui::package::{Self, Publisher};
    use sui::test_scenario as ts;
    use sui::test_utils::assert_eq;

    const ADMIN: address = @0xAA;

    public struct HERO_TEST has drop {}

    fun init(otw: HERO_TEST, ctx: &mut TxContext) {
        package::claim_and_keep(otw, ctx);
    }

    #[test, expected_failure(abort_code = hero::EWrongPublisher)]
    fun test_publisher_cannot_mint_hero_with_wrong_publisher_object() {
        let mut ts = ts::begin(ADMIN);

        assert_eq(ts::has_most_recent_for_address<Publisher>(ADMIN), false);

        init(HERO_TEST {}, ts.ctx());

        ts.next_tx(ADMIN);

        let publisher = ts.take_from_sender<Publisher>();

        let _hero = hero::create_hero(&publisher, b"Hero 1".to_string(), ts.ctx());

        abort (1337)
    }
}
