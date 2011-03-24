#! /usr/bin/env python
# -*- encoding:utf-8 -*-
# FileName: a.py

import hashlib

def get_hexdigest(algorithm, salt, raw_password):
    """
    Returns a string of the hexdigest of the given plaintext password and salt
    using the given algorithm ('md5', 'sha1' or 'crypt').
    """
    if algorithm == 'crypt':
        try:
            import crypt
        except ImportError:
            raise ValueError('"crypt" password algorithm not supported in this environment')
        return crypt.crypt(raw_password, salt)

    if algorithm == 'md5':
        return hashlib.md5(salt + raw_password).hexdigest()
    elif algorithm == 'sha1':
        return hashlib.sha1(salt + raw_password).hexdigest()
    raise ValueError("Got unknown password algorithm type in password.")

def check_password(raw_password, enc_password):
    """
    Returns a boolean of whether the raw_password was correct. Handles
    encryption formats behind the scenes.
    """
    algo, salt, hsh = enc_password.split('$')
    return hsh == get_hexdigest(algo, salt, raw_password)

def set_password(raw_password):
    import random
    algo = 'sha1'
    salt = get_hexdigest(algo, str(random.random()), str(random.random()))[:5]
    hsh = get_hexdigest(algo, salt, raw_password)
    password = '%s$%s$%s' % (algo, salt, hsh)
    return password

if __name__=="__main__":
    print check_password("abc123","sha1$42bd7$24eafbd1cb1522eea59c32ec82211be947221578")
    print check_password("abc123","sha1$ac016$8271fbe00ebf5191be446b895a4448b6b161a788")
    print check_password("abc123","sha1$2d690$aa6b6eec2dbb9bf1bf89fecab5e0e076658ab1e6")
