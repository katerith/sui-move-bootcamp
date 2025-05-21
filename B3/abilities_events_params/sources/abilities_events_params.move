module abilities_events_params::abilities_events_params {
    use std::string::String;
    use sui::event;

    //Error Codes
    // const EMedalOfHonorNotAvailable: u64 = 111;

    // Structs

    public struct Hero has key {
        id: UID, // required
        name: String,
        medals: vector<Medal>,
    }

    public struct HeroMinted has copy, drop {
        hero: ID,
        owner: address,
    }

    public struct HeroRegistry has key, store {
        id: UID,
        heroes: vector<ID>,
    }

    public struct Medal has key, store {
        id: UID,
        name: String,
    }

    // Module Initializer
    fun init(ctx: &mut TxContext) {
        let registry = HeroRegistry {
            id: object::new(ctx), // creates a new UID
            heroes: vector[],
        };
        transfer::share_object(registry);
    }

    public fun mint_hero(name: String, registry: &mut HeroRegistry, ctx: &mut TxContext): Hero {
        let freshHero = Hero {
            id: object::new(ctx), // creates a new UID
            name,
            medals: vector[],
        };
        registry.heroes.push_back(object::id(&freshHero));

        let minted = HeroMinted {
            hero: object::id(&freshHero),
            owner: ctx.sender(),
        };
        event::emit(minted);
        
        freshHero
    }

    public fun mint_and_keep_hero(registry: &mut HeroRegistry, name: String, ctx: &mut TxContext) {
        let hero = mint_hero(name, registry, ctx);
        transfer::transfer(hero, ctx.sender());
    }

    public fun award_medal_of_honor(hero: &mut Hero, ctx: &mut TxContext) {
        let medal = Medal {
            id: object::new(ctx),
            name: b"Medal of Honor".to_string(),
        };
        hero.medals.push_back(medal);
    }

    /////// Tests ///////

#[test_only]
use sui::test_scenario as ts;
#[test_only]
use sui::test_scenario::{take_shared, return_shared};
#[test_only]
use sui::test_utils::{destroy};

//--------------------------------------------------------------
//  Test 1: Hero Creation
//--------------------------------------------------------------
//  Objective: Verify the correct creation of a Hero object.
//  Tasks:
//      1. Complete the test by calling the `mint_hero` function with a hero name.
//      2. Assert that the created Hero's name matches the provided name.
//      3. Properly clean up the created Hero object using `destroy`.
//--------------------------------------------------------------
#[test]
fun test_hero_creation() {
    let mut test = ts::begin(@USER);
    init(test.ctx());
    test.next_tx(@USER);

    //Get hero Registry
    
    let mut registry = take_shared<HeroRegistry>(&test);
    let name = b"Luffy".to_string();
    let hero = mint_hero(name, &mut registry, test.ctx());

    assert!(name == hero.name, 666);

    return_shared(registry);
    destroy(hero);
    test.end();
}

//--------------------------------------------------------------
//  Test 2: Event Emission
//--------------------------------------------------------------
//  Objective: Implement event emission during hero creation and verify its correctness.
//  Tasks:
//      1. Define a `HeroMinted` event struct with appropriate fields (e.g., hero ID, owner address).  Remember to add `copy, drop` abilities!
//      2. Emit the `HeroMinted` event within the `mint_hero` function after creating the Hero.
//      3. In this test, capture emitted events using `event::events_by_type<HeroMinted>()`.
//      4. Assert that the number of emitted `HeroMinted` events is 1.
//      5. Assert that the `owner` field of the emitted event matches the expected address (e.g., @USER).
//--------------------------------------------------------------
#[test]
fun test_event_thrown() { 
    let mut test = ts::begin(@USER);
    init(test.ctx());
    test.next_tx(@USER);

    let mut registry = take_shared<HeroRegistry>(&test);
    let name = b"Luffy".to_string();
    let hero = mint_hero(name, &mut registry, test.ctx());
    let events = event::events_by_type<HeroMinted>();

    assert!(events.length() == 1, 666);
    assert!(events[0].owner == @USER, 666);

    return_shared(registry);
    destroy(hero);
    test.end();
}

//--------------------------------------------------------------
//  Test 3: Medal Awarding
//--------------------------------------------------------------
//  Objective: Implement medal awarding functionality to heroes and verify its effects.
//  Tasks:
//      1. Define a `Medal` struct with appropriate fields (e.g., medal ID, medal name). Remember to add `key, store` abilities!
//      2. Add a `medals: vector<Medal>` field to the `Hero` struct to store the medals a hero has earned.
//      3. Create functions to award medals to heroes, e.g., `award_medal_of_honor(hero: &mut Hero)`.
//      4. In this test, mint a hero.
//      5. Award a specific medal (e.g., Medal of Honor) to the hero using your `award_medal_of_honor` function.
//      6. Assert that the hero's `medals` vector now contains the awarded medal.
//      7. Consider creating a shared `MedalStorage` object to manage the available medals.
//--------------------------------------------------------------
#[test]
fun test_medal_award() { 
    let mut test = ts::begin(@USER);
    init(test.ctx());
    test.next_tx(@USER);

    let mut registry = take_shared<HeroRegistry>(&test);
    let name = b"Luffy".to_string();
    let mut hero = mint_hero(name, &mut registry, test.ctx());

    // Award a medal to the hero
    award_medal_of_honor(&mut hero, test.ctx());

    // Assert that the hero's medals vector contains the awarded medal
    assert!(hero.medals.length() == 1, 666);
    assert!(hero.medals[0].name == b"Medal of Honor".to_string(), 666);

    return_shared(registry);
    destroy(hero);
    test.end();
 }

}