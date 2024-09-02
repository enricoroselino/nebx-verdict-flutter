# Nebx Verdict

[![Pub](https://img.shields.io/pub/v/nebx_verdict.svg)](https://pub.dev/packages/nebx_verdict)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/enricoroselino/nebx-verdict-flutter/blob/main/LICENSE)


Nebx Verdict is a result pattern to simplify error handling.

## Get started

### Install
Add the `nebx_verdict` package to your [pubspec dependencies](https://pub.dev/packages/nebx_verdict/install).

## Examples

Performing error handling :

```dart
class SomeRepository {
    IVerdict<SomeDataModel> getDataSuccess() {
        final result = successRemoteData();
        // you can fail fast here using guard clause
        
        // if using failedRemoteData(), then it's gonna returning ....
        // failed verdict with forbidden status / message
        if (result.isFailure) return Verdict.failed(result.issue);
        
        late final SomeDataModel model;
        
        try {
            model = SomeDataModel.fromJson(result.data);
        } catch (e) {
            return Verdict.failed(Issue.parsing());
        }
        
        // if the SomeDataModel.fromJson not throwing error
        // you will returning data with success
        return Verdict.successful(model);
    }
}

// pretending as a server returning JSON of SomeDataModel
IVerdict<SomeDataModel> successRemoteData() {
    final data = SomeDataModel(
        id: "492e1e70-597e-4f07-adc1-625fdd0efd71",
        name : "roselino",
        country_id : "ID"
    );
    
    // pretend as returning JSON from remote
    return Verdict.successful(data);
    }
    
IVerdict<SomeDataModel> failedRemoteData() {
    try {
       // ..... do something 
       // then pretend we got forbidden from error handling mapper
       // please check nebx package for easy dio error handling
       // https://pub.dev/packages/nebx/install
    } catch (e) {
        // then you will be returning with forbidden verdict
        return Verdict.failed(Issue.forbidden());
    }
    return Verdict.successful(data);
}
```
