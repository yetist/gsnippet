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
