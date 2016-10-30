-module(pkey_cert_records).
-compile(export_all).

-include_lib("public_key/include/public_key.hrl").

-define(DER_NULL, <<5, 0>>).

public_key_algorithm_oid('RSAPublicKey') -> ?'rsaEncryption';
public_key_algorithm_oid('DSAPublicKey') -> ?'id-dsa';
public_key_algorithm_oid('DHPublicKey') -> ?'dhpublicnumber';
public_key_algorithm_oid('KEA-PublicKey') -> ?'id-keyExchangeAlgorithm';
public_key_algorithm_oid('ECPoint') -> ?'id-ecPublicKey'.

der_null() -> ?DER_NULL.