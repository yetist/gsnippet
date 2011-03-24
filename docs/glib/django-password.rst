===========================
django加密算法的glib实现
===========================

.. contents::

某项目，B/S+C/S结构，B端使用django框架，C端用到了glib库，为了使C端保存的用户密码能被B端的django验证通过，需要在C端按同样算法加密原始密码。

先从django中摘出其密码实现代码，如下：


$ cat /tmp/a.py

.. code-block:: python
  
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

可以看到，django支持crypt、md5和sha1三种加密算法，我们只取sha1这一种即可。对照python代码，使用glib实现的代码如下：

.. code-block:: c
  
  #include <string.h>
  #include <glib.h>
  #include <stdio.h>
  
  gchar* get_hexdigest(const gchar *salt, const gchar *raw_password)
  {
      gchar *str;
      gchar *password;
      str = g_strdup_printf("%s%s", salt, raw_password);
      password = g_compute_checksum_for_string (G_CHECKSUM_SHA1, str, strlen(str));
      g_free(str);
      return password;
  }
  
  gchar* set_password(const gchar *raw_password)
  {
      gchar *salt;
      gchar *hsh;
      gchar *str1, *str2;
      gchar *password;
      gdouble rand;
  
      rand = g_random_double();
      str1 = g_strdup_printf("%g", rand);
      rand = g_random_double();
      str2 = g_strdup_printf("%g", rand);
  
      salt = get_hexdigest(str1, str2);
      salt[5] = '\0';
      g_free(str1);
      g_free(str2);
  
      hsh = get_hexdigest(salt, raw_password);
  
      password = g_strdup_printf("sha1$%s$%s", salt, hsh);
      g_free(salt);
      g_free(hsh);
      return password;
  }
  
  int main(int argc, char **argv)
  {
      printf("%s\n", set_password("abc123"));
      return 0;
  }

C代码执行后产生的密码通过python程序验证通过，OK。
