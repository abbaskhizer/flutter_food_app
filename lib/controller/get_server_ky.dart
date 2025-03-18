import 'package:googleapis_auth/auth_io.dart';


class GetServerKey {
  Future<String> getServerKeyToken()async{
    final scopes =[
      'https://www.googleapis.com/auth/userinfo.email',
       'https://www.googleapis.com/auth/firebase.database',
        'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client =await clientViaServiceAccount(ServiceAccountCredentials.fromJson({
      
  "type": "service_account",
  "project_id": "foodie-5bc9b",
  "private_key_id": "5516269f05996ec3c73a26d276d6606a5caee287",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDzWvghldi2+d/U\nJbNVXhGekjZ0EFVJ4tk9q1338R9GGgshT8VxqY9kzzBGM2m/i39O4ThOOaMpXLGc\nW3Hnmr9oQ8lILzbN3noY5HnQp5rBzHqxeYqM3k7u1gavXpsSHaFwdPnb5BMNdpq7\nFDMulPLHVxJWC0dxKHrJ+TYy5qGaE2FDQ+Zrdy6hFGeYT/Fdp9yXFK4wRxtjk8fE\ni4QXTVoDTgUr7O5MNHVXAtVU5Sco3i5FJkAVXjJyMPsPtZdXz+V1gH7CbHQXi8GW\n9Fe9iPnyF+va9RKGvHsvLMtPWwXTomBBq4LzsTYNDbNyod6uOfUMdB0ApFTrTL8B\nsEzCaztpAgMBAAECggEAHXFdiUm1DkFJ44PasErI8LGhuTXjLcTukfOmczm29g8v\nVszNF4kDZnfbUDkG87Pr15Yv7uXyD85tVjypmbMLMrEV3KAKvkprJREajGRE2Or1\nkryg5tV8QRD/vs7ATgcr+bxLYR91byjxBE6nuRxwCa5nE2Y6su4J+h8G385v0aFH\nd0zBLNkZ9L+iG8J0jaP8/FHNYy6Sh0+RW5WjlKLYARTxKR3X6BpO3wYj/b3SUWZn\nG+PQwSvPC/hwDGIJ6L3PsOK7Jgsxxgol1pwWrY4WQKLXbUhpo68/PCmPE9pFSeJR\natnrirgDFlqk2PSvVa8REdx6psyGWui8hiK7fC1BkQKBgQD/Gwcb5BVxTT4j5wxY\nC4fZc5NWcna47wSNaTs5vCO/DCYCio7iqBt2JeI7VTCvsGVngo3CjxNKuxxFPw1H\n12OQ44RvyhAw7p6MWxUldH1YtTlhdOEZ2mfwDNGcc/NboCOnZEc5bSNC3Nbaurt8\nNXY1NvNkjbv7AXMj4JxqK8PC8QKBgQD0NWUc98jmVvIWZgohu/k1XJ42Pb2afMoQ\nVeXTciHnlSZU5r3qAC21jIEoD6saEGDmjWxKRVv7QFVXmy5P+AUIitoWoyV/v8ke\nwSWddlaVg8hUb8sQXzwgMIxraIg3etb0RAGMQJfLnjiwPIzTb83ucwRIGcKboDHO\nNbhpLP6P+QKBgQDP2aCoK+UApLPNotHe5r4wAUf5tldfBHfMFAJKXy0s2uQZS/Vx\nXRDK6cDzIM0DSJDGjoucCuDoEZ3OGbpjX23jPkzInHUmuTT7HLcVBl2eqkFvU0CY\nxOfMoVUjySFt9QM3vq99bZu+PZrdKinZ4OFIKFaVBho0QBElGTu4EaJ1sQKBgQCH\n9tJ89lgcJnxSjC1H6ugtFYvgly9hO+kkfy6eMwU9coUM8Ar8pWzNj5S5QT/6GvRY\naJTKJSO5F3BsfjGixGvI/cW+pMbUAWtwfAj9Sk2aoOyAVl2wl9VZ9q23f1OX0ASt\nqs9RzwS0kTrupEej0LPO9qqDmhQHoYEZVj9+D1cLwQKBgFGNDxLC0n6LRFTbL88f\nfds6UDWfJjXX9ahjtrToK4zFw5ilWi6/+OwpTZZ9ZrVBrWPUwdM3fUbVFv9esSAX\nZXcusm4EwvDerrN4tVds699pPPokP+2EeKefQDVFM94EQLRFLPRZRdoBaRB4+KlM\nYt2F2Ig3CzUPaRZkCb7pQg+p\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-7rw9g@foodie-5bc9b.iam.gserviceaccount.com",
  "client_id": "106013162266491265350",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-7rw9g%40foodie-5bc9b.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"



    }), scopes);
    final accessServerKey=client.credentials.accessToken.data;
    return accessServerKey;
  }
  
}