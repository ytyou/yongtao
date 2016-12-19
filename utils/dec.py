import binascii
import Crypto.Cipher
import Crypto.Hash.HMAC
import Crypto.Hash.SHA256
import Crypto.PublicKey.RSA
import sys
import md5

token = sys.argv[1]

# padding
while len(token) % 32 != 0:
    token += "00"

user_Rands_Password = "my_password"

m1 = md5.new()
m1.update(user_Rands_Password)
key = m1.hexdigest()

m2 = md5.new()
m2.update(key)
key_str = m2.hexdigest()


encrypted = binascii.unhexlify(token)

iv = encrypted[:Crypto.Cipher.AES.block_size]
text = encrypted[Crypto.Cipher.AES.block_size:]

cipher = Crypto.Cipher.AES.new(
            key=key_str,
            mode=Crypto.Cipher.AES.MODE_CFB,
            IV=iv,
            segment_size=Crypto.Cipher.AES.block_size*8)

text = cipher.decrypt(text)
text = text.decode('base64')

print text
