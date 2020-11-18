#!/usr/bin/perl
use JSON;
use Data::Dumper;

$json ='{
  "firstName": "Bidhan",
  "lastName": "Chatterjee",
  "age": 40,
  "address": [
    {
      "Home": {
        "streetAddress": "144 J B Hazra Road",
        "city": "Burdwan",
        "state": "Paschimbanga",
        "postalCode": "713102"
      }
    },
        {
      "Office": {
        "streetAddress": "Office 144 J B Hazra Road",
        "city": "Office Burdwan",
        "state": "Office Paschimbanga",
        "postalCode": "as713102"
      }
    }
  ],
  "phoneNumber": [
    {
      "type": "personal",
      "number": "09832209761"
    },
    {
      "type": "fax",
      "number": "91-342-2567692"
    }
  ]
}';

$text = decode_json($json);

print $$text{"address"}[0]{"Home"}{"postalCode"};
#
#print  Dumper($text);
