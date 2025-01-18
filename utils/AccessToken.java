package com.example.chatappfirebase.utils;

import android.util.Log;
import com.google.auth.oauth2.GoogleCredentials;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class AccessToken {
    private static final String firebaseMessagingScope =
            "https://www.googleapis.com/auth/firebase.messaging";

    public String getAccessToken() {
        try {
            String jsonString = "{\n" +
                    "  \"type\": \"service_account\",\n" +
                    "  \"project_id\": \"chatappfirebase-3ebb8\",\n" +
                    "  \"private_key_id\": \"4693b1879572b0d9479e9280a8bf94936c1af3ad\",\n" +
                    "  \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDbEg0XD0sYVdMZ\\n1xibetL/BmXqoCMPpgScGkMh28GirFAPS5WMfFNODLgsAykEka72cjdVHnokq5h8\\nSOmYXKexmF6MSHIMnGR/0VSGVRtqracQhDML5JyvVGCDpCsTnFcxNA/mtFLr2bKk\\nhe2B7GSMHkXPYcvpYjjpeA4JRCelibY7R/9YFyozzmDu/VlGQXrsVeSoBZ3Q5Xjb\\nN3p2wP9Lk/N0aYCwfyTqHJiM5Wx/cfn1KXWRbiv5sa3v0uCmLPGH8vVXuzC78tUL\\nSSbGVR1KTcll5eMUafZSaiMfCx8778T4IzrkHVESsj4OlO+uOMpvwfxDIAhZrGzr\\nAAUHtm7bAgMBAAECggEAE8rItfmivjsazG3bgkiRgYrxcEYxhLtqFTRmNkvlba4F\\nuawJgdzFpfqONSO/8/K5jPh6uUz8mg2KxEfOGv7cA7aRbDkrXKpQhh/CdDSCOpwf\\nyOU4u21XHpwP8DTH04i/c+mROjW2fCp58lVLRP63gtVFV1wtkRNXsvguxHWM426n\\n0Hy9AApQVXul0WKAgrsK3IlIEkzSom1QBrmna2mffYtKBH2ku4rK2eTIcA095Ods\\nSdbKG5e1jjofwJhQnt7tCQ1dbTJ7dcSM8n5vC8ebQ/NKrzOl/IegUIfVhrI2zis4\\ndM5jLyZZkOPEsKdWS/2URzUsuXbVe8oJrMNu29G9EQKBgQD8VJVATcx3Qpu+CgZO\\n5fwC661gLfyMWEYXSo2uH5wLA1x50p/whVx2WeMnsgG8udX2WNhknOmWdqblTsxk\\ndwCvjhQ30YUgV7ueZCzbKdjDct7FSdgIMHO+RL+pSEPNN8FtJu47hoUJUKzjLOLY\\ncxzfmKrJmDGWjgKQe5diUgV4iQKBgQDeQaSLNbr3b8sd0BF2U34rMMYQiTc/P0tE\\ngkePVOTtDfG2Fdjm+m3aKKWaU1C64JMvhulYc2xdkTzD7a4D2cIeF1b1cn/h8fxh\\ntr7W0l9slPS3pajkF48bo/2o0ELd9FsFn+GuqgNNMfzP/VJ/i4iDsD7DAT/cLBmx\\nQEbieMoLQwKBgQDklw+6+H/xzqLez6AVW94pGy6uwhpXXiTpNr4Rb0ti4sGlDz2b\\nnIU+JoJV1LokKcp+6M/ongozJ/xcIj2iCfjSEYmZY7MRsMkkXaYRSeC4d1j/K72M\\n9a/1P7zN88yQniEZ7DnILT5aSP7Gs0QySF5w5ZJbHQhXVwFVuNFU3e9c2QKBgBvd\\nzRyrMvL9MFFfmiDk3QfbSKogGi4y6GQBlalR8pYKTokO+jATrBxTRlgwJAoaSDoI\\nR0+QwUCGCkFilpPjBKSzNnL11TTmG0fBGvJiVBaQIpK4EZHvpkDH8fDtk8Syc4sj\\n/a7hoCJYpyMI1wQo4YfpXCUlDfW0DdCch4azsFlzAoGBANWGNkifm/WbRxr5Nlp5\\nnaFQ2dbtHzAFnylV6N45y7Y0s9m5DaK5iPIcIPHLkVYrZfS+t7CYlXMSo1m4RK+X\\nF49kSpkAyDWOnee5XWdyS5o5/V6gYJbWu8Rrx+OFo55nlfVQkgJ4MWM+PFFh7XVP\\nwtMYOzsroq6jaQlYnKrFxejT\\n-----END PRIVATE KEY-----\\n\",\n" +
                    "  \"client_email\": \"firebase-adminsdk-dezkq@chatappfirebase-3ebb8.iam.gserviceaccount.com\",\n" +
                    "  \"client_id\": \"115367562756296346657\",\n" +
                    "  \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",\n" +
                    "  \"token_uri\": \"https://oauth2.googleapis.com/token\",\n" +
                    "  \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",\n" +
                    "  \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-dezkq%40chatappfirebase-3ebb8.iam.gserviceaccount.com\",\n" +
                    "  \"universe_domain\": \"googleapis.com\"\n" +
                    "}";
            InputStream stream = new ByteArrayInputStream(jsonString.getBytes(StandardCharsets.UTF_8));
            GoogleCredentials googleCredentials = GoogleCredentials.fromStream(stream).createScoped(firebaseMessagingScope);
            googleCredentials.refresh();
            return googleCredentials.getAccessToken().getTokenValue();
        } catch (Exception e) {
            Log.e("AccessToken", "getAccessToken: " + e.getLocalizedMessage());
            return null;
        }
    }
}