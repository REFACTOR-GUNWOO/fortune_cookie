import 'dart:math';

import 'package:fortune_cookie_flutter/category.dart';
import 'package:fortune_cookie_flutter/synerge.dart';
import 'package:gsheets/gsheets.dart';

class GSheetAPIConfig {
  static const _credentials = r'''
{
  "type": "service_account",
  "project_id": "fortunecookie-398509",
  "private_key_id": "6e20acea29d6e1c987a9cc4050b910714389895f",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCjI/8m8Hrl2lng\nRtbfyWDe9RCEid3NWkZhyV/+BQjf7QPimz7kZi6e4FwhDgi74UtpERJ0WDCrgTSy\ntueCkXtX20jhlZSes8ooEn1SHZbX28bnWfBGvprX6yRANXtoGTvbqEyFBlUGhq6v\nFFtVVT5HZDKFveQCQVzSQWXoS3bxAC4EF5n23LSyP6usQLrRQyY/opECnANziS0J\nKlpPoXlbOA1L680w8z5ykkww7v0JUga/UHRXyAQXN0whkTInj/UWNCbMcTTBgr0d\n/GuFLpNJp3l/T4Tn21EH4yB58cX9tSUr54yT/quSYlHYoAJ6OH5f1EL4rSEW+4O2\noO2ii8dHAgMBAAECggEATSpeqvV+vDAe6PW491tShcNXD8oCbvqvZduRmx6Yhwqe\nFtal1fT7Qk0PZtczjGLRf54Co6N/SfAwlAPt15WmyPTBMWrGRJb4HSI5wtiaG/op\nyA6Dl4LazRy9Jd3mRGQDKzAdGaLYHuEfyVKQrPlIHw6m0xnxupteI1mpsUnYtb9F\nZMiDKiCMkQQQ9eP6xeVQK+nwv3mbAj2vjoOODUa6ldOLaNVj3+11tGO6MkjiTzWt\nJa0Ui/B/qbEemU3gSJiqwAn24vO5UYEB490zH3oO/VyTgdXfJOer4UKkKfUYIWGG\nX+Z7350XMxaFLTNR9Q0sEW4lsAhMnwYcV7mE11+W6QKBgQDX+TjqZxqij1u5jd8u\no/nk5mmLbEtxRPOR3+M6OqXhH+7cfRgsh9lz0EJVbHieOIRCiKGbSz9mAjx+URH5\n0mcYwlX5S9e2oADzdP5bOCUIdgxTERmJo+lXLRpIOIzlO1EdzjeaNDVsg7sKf7i4\nq8j+9CitYcJ+GMf55RO/SPvvwwKBgQDBYCNOACgFwJxtx37iSZyMWUvP9EIykXr9\nvUIIlIScGaPwg4EL8z3EktuCJKeeP0JSVAw5E6CPyyCTPiwDM/HsYl0ViZAmeZ7l\nJRkPbZ+Gt/5oeA9XSBWL4QYG98b0A4smh4ZxOKiPtwKUo6l7TcLsIvQwy4wIOI6R\nIOgsyBq2LQKBgQCzLg1OS6QJYi6TT2TuaRSWF6NRDNO6cZ4yVDFMygN9NuURAKfh\nqgN61jlybb/UZMc1++03zcIXe5t8oP3s6eam3/Q8E/Qvi6e+VD4CqB3xWx72e6VY\nUCjzLnQzntcmB4RQ2hm/UblRAilXmIdEjyD+hMqKriSSQTUH2kn71S1PyQKBgBdE\nyDrEjgxTJv+Wt8/m562DuTmmvKh1FQWfVmjN5j8aXr28NTUI6e/TdBJu8rR6DDL3\n5higIfvrh1nwaz9fasb09xp2WSAoFlSgaCmRGVcOoNBVUhNAm0cfpqgD/K60FnRm\nbmkFVlMkxGy6XNR3gPMFKbkNZSZAF/eirA1nbr9pAoGBANSj4aIiJnCcba67g6IM\nglHvaXaMkA+vh8aB1cMZ2lJCDXmOADXALBFhSohV4Kh+yval0DtMMa4ATY7YduKG\no/l7kTEqOHeKHdNTmc4bUL6EBBYluLfdD0fSvrxK06BfuexfgkwWPDsORNTJiXQR\nEQCP2F3aDM81dKDHkygiNoKf\n-----END PRIVATE KEY-----\n",
  "client_email": "kakaloto85@fortunecookie-398509.iam.gserviceaccount.com",
  "client_id": "107983040461743525469",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/kakaloto85%40fortunecookie-398509.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';
  static final candyGSheets = GSheets(_credentials);
}

class FortuneRepository {
  static final String _spreadsheetId =
      '13vcEhthcDAW-r3FEnOR9YSaw69pyeAI7zArjwgvNr64';
  // final String _workSheetTitle = 'today';

  static Spreadsheet? spreadsheet;
  // late Worksheet? workSheet;

  static Future<void> initalWorkSheet() async {
    if (spreadsheet == null) {
      final gseets = GSheetAPIConfig.candyGSheets;
      spreadsheet = await gseets.spreadsheet(_spreadsheetId);
    } else {
      print("already initialized work sheet");
    }
  }

  Future<String> getFortune(Category category) async {
    await initalWorkSheet();
    final _random = new Random();
    Worksheet sheet = spreadsheet!.sheets
        .where((element) => element.title == category.code)
        .first;
    int randomIndex = _random.nextInt(sheet.rowCount) + 1;
    print(randomIndex);
    return (await sheet.values.row(randomIndex)).first;
  }
}

class SynergeRepository {
  static final String _spreadsheetId =
      '13vcEhthcDAW-r3FEnOR9YSaw69pyeAI7zArjwgvNr64';
  // final String _workSheetTitle = 'today';

  static Spreadsheet? spreadsheet;
  // late Worksheet? workSheet;

  static Future<void> initalWorkSheet() async {
    if (spreadsheet == null) {
      final gseets = GSheetAPIConfig.candyGSheets;
      spreadsheet = await gseets.spreadsheet(_spreadsheetId);
    } else {
      print("already initialized work sheet");
    }
  }

  Future<BaseSynerge> getSynerge(SynergeType synergeType) async {
    await initalWorkSheet();
    final _random = new Random();
    print(spreadsheet!.sheets.last.title);
    print("synerge_${synergeType.name}");
    Worksheet sheet = spreadsheet!.sheets
        .where((element) => element.title == "synergy_${synergeType.name}")
        .first;
    int randomIndex = _random.nextInt(sheet.rowCount) + 1;
    print(randomIndex);
    if (synergeType == SynergeType.color) {
      return ColorSynerge((await sheet.values.row(randomIndex)).first,
          (await sheet.values.row(randomIndex))[1]);
    }
    if (synergeType == SynergeType.place) {
      return PlaceSynerge((await sheet.values.row(randomIndex)).first);
    }
    if (synergeType == SynergeType.stuff) {
      return StuffSynerge((await sheet.values.row(randomIndex)).first);
    }

    throw Error();
  }
}
