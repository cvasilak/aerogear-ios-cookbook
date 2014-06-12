/*
 * JBoss, Home of Professional Open Source.
 * Copyright Red Hat, Inc., and individual contributors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "ProductsViewController.h"

#import <AeroGear.h>
#import <SVProgressHUD.h>

@interface ProductsViewController () {
    __weak IBOutlet UIButton *revokeBut;
    __weak IBOutlet UIBarButtonItem *refreshBut;
    
    // holds the data from the server
    NSArray *_data;
    
    id<AGPipe> _pipe;
    id<AGAuthzModule> _restAuthzModule;
}

@end

@implementation ProductsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize pop-up warning to start OAuth2 authz
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Authorize Keycloak" message:@"You will be redirected to Keycloak to authenticate and grant access." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self authorize];
}

- (IBAction)authorize {
    AGAuthorizer *authorizer = [AGAuthorizer authorizer];

    _restAuthzModule = [authorizer authz:^(id<AGAuthzConfig> config) {
        config.name = @"keycloak";
        config.baseURL = [NSURL URLWithString:@"http://localhost:8080/auth"];
        config.authzEndpoint = @"/rest/realms/product-inventory/tokens/login";
        config.accessTokenEndpoint = @"/rest/realms/product-inventory/tokens/access/codes";
        config.revokeTokenEndpoint = @"???????????????";
        config.clientId = @"product-inventory";
        config.redirectURL = @"org.aerogear.KeycloakDemo://oauth2Callback";
    }];
    
    AGPipeline *databasePipeline = [AGPipeline pipelineWithBaseURL:
                                                [NSURL URLWithString:@"http://localhost:8080/aerogear-integration-tests-server/rest"]];
    
    _pipe = [databasePipeline pipe:^(id<AGPipeConfig> config) {
        [config setName:@"/portal/products"];
        [config setAuthzModule:_restAuthzModule];
    }];
    
    [self refresh:nil];
}

- (IBAction)revoke:(id)sender {
    [_restAuthzModule revokeAccessSuccess:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"Token was revoked successfully!"];
        
        revokeBut.enabled = NO;
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription] ];
    }];
}

- (IBAction)refresh:(id)sender {
    // read from pipe
    [_pipe read:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"Successfully fetched data!"];
        
        _data = responseObject;
        
        revokeBut.enabled = YES;
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *element = _data[indexPath.row];
    cell.textLabel.text = element[@"name"];
    return cell;
}

@end
