program aleo_user_pass.aleo;

struct TokenIdentifier:
    part_one as u128;
    part_two as u128;

struct URIComponents:
    segment_one as u128;
    segment_two as u128;

struct UserAlias:
    piece_one as u128;
    piece_two as u128;
    piece_three as u128;
    piece_four as u128;

struct CollectionSymbol:
    encoded_value as u128;

struct Credential:
    credential_holder as address;
    alias as UserAlias;
    registered_at as u64;
    achievement_points as u32;
    membership_level as u32;

record IdentityToken:
    owner as address.private;
    identifier as TokenIdentifier.private;
    variant as scalar.private;
    credential as Credential.private;


mapping control_flags:
	key as u8.public;
	value as u32.public;


mapping configuration_params:
	key as u8.public;
	value as u128.public;


mapping registry:
	key as address.public;
	value as Credential.public;


mapping registry_by_alias:
	key as UserAlias.public;
	value as Credential.public;

closure calculate_membership:
    input r0 as u32;
    lte r0 20u32 into r1;
    lt r0 80u32 into r2;
    not r1 into r3;
    and r3 r2 into r4;
    ternary r4 1u32 2u32 into r5;
    ternary r1 0u32 r5 into r6;
    output r6 as u32;


function setup_collection:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as URIComponents.public;
    assert.eq self.caller aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl;
    async setup_collection r0 r1 r2 into r3;
    output r3 as aleo_user_pass.aleo/setup_collection.future;

finalize setup_collection:
    input r0 as u128.public;
    input r1 as u128.public;
    input r2 as URIComponents.public;
    get.or_use control_flags[0u8] 0u32 into r3;
    assert.eq r3 0u32;
    set 0u128 into configuration_params[0u8];
    set r0 into configuration_params[1u8];
    set r1 into configuration_params[2u8];
    set r2.segment_one into configuration_params[3u8];
    set r2.segment_two into configuration_params[4u8];
    set 5u32 into control_flags[0u8];
    set 0u32 into control_flags[1u8];


function refresh_uri:
    input r0 as URIComponents.public;
    assert.eq self.caller aleo1geqft8epz9kurdv7fqfrwe4l75dw240jvhmt9x7ennftz9gt2q8q86hzjl;
    async refresh_uri r0 into r1;
    output r1 as aleo_user_pass.aleo/refresh_uri.future;

finalize refresh_uri:
    input r0 as URIComponents.public;
    get.or_use control_flags[0u8] 1u32 into r1;
    assert.eq r1 1u32;
    set r0.segment_one into configuration_params[3u8];
    set r0.segment_two into configuration_params[4u8];


function issue_identity:
    input r0 as UserAlias.public;
    input r1 as TokenIdentifier.public;
    input r2 as scalar.public;
    input r3 as u64.public;
    input r4 as u32.public;
    call calculate_membership r4 into r5;
    cast self.caller r0 r3 r4 r5 into r6 as Credential;
    cast self.caller r1 r2 r6 into r7 as IdentityToken.record;
    async issue_identity self.caller r0 r6 into r8;
    output r7 as IdentityToken.record;
    output r8 as aleo_user_pass.aleo/issue_identity.future;

finalize issue_identity:
    input r0 as address.public;
    input r1 as UserAlias.public;
    input r2 as Credential.public;
    get registry[r0] into r3;
    or r3.registered_at 0u64 into r4;
    get registry_by_alias[r1] into r5;
    or r5.registered_at 0u64 into r6;
    assert.eq r4 0u64;
    assert.eq r6 0u64;
    get.or_use control_flags[0u8] 0u32 into r7;
    assert.neq r7 0u32;
    set r2 into registry[r0];
    set r2 into registry_by_alias[r1];
