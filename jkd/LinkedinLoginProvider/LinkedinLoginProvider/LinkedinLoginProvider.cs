using System;
using System.Linq;
using System.Web;
using Owin;
using Dynamicweb.Extensibility;
using Dynamicweb.Extensibility.Editors;
using Microsoft.Owin.Security;
using System.Security.Claims;
using Dynamicweb.Content.Social.Adapters.ExternalAuthentication;
using Owin.Security.Providers.LinkedIn;
using System.Diagnostics;


[AddInName("Linkedin"), AddInDescription("Linkedinloginprovider."), AddInIgnore(false)]
public class LinkedinLoginProvider : LoginProvider
{
    /// <summary>
    /// Gets or sets the client id.
    /// </summary>        
    [AddInLabel("Client ID"), AddInParameter("ClientID"), AddInParameterEditor(typeof(TextParameterEditor), "inputClass=std")]
    public string ClientID { get; set; }

    /// <summary>
    /// Gets or sets the client secret.
    /// </summary>        
    [AddInLabel("Client secret"), AddInParameter("ClientSecret"), AddInParameterEditor(typeof(TextParameterEditor), "inputClass=std")]
    public string ClientSecret { get; set; }
    private static readonly object syncLock = new object();
    private static readonly string AuthenticationProviderName = "LinkedIn";


    /// <summary>
    /// Settings for the Oauth provider
    /// </summary>
    private static LinkedInAuthenticationOptions _LinkedinOAuth2AuthenticationOptions = new LinkedInAuthenticationOptions()
    {
        AuthenticationType = AuthenticationProviderName,
        CallbackPath = new Microsoft.Owin.PathString("/signin-linkedin"),
        ClientId = "test",
        ClientSecret = "test"
    };
    /// <summary>
    /// empty constructor - needed for configurable addin
    /// </summary>
    public LinkedinLoginProvider()
    {
    }
    /// <summary>
    /// method for registering oauth provider during application start. Required by OAuth standard
    /// </summary>
    /// <param name="app"></param>
    public override void RegisterProvider(IAppBuilder app)
    {
        app.UseLinkedInAuthentication(_LinkedinOAuth2AuthenticationOptions);
    }


    /// <summary>
    /// method called when login is requested from frontend. redirects to oauth provider - in this case, to LinkedIn.
    /// return redirect is handled by notification subscriber in "AuthenticareRequestSubscriber".
    /// </summary>
    public override void Login()
    {
        //Change Authentication Options to use ClientID and Secret from Provider Settings
        lock (syncLock)
        {
            _LinkedinOAuth2AuthenticationOptions.ClientId = ClientID;
            _LinkedinOAuth2AuthenticationOptions.ClientSecret = ClientSecret;
        }

        AuthenticationProperties properties = new AuthenticationProperties() { RedirectUri = RedirectUrl };
        HttpContext.Current.GetOwinContext().Authentication.Challenge(properties, AuthenticationProviderName);
    }
}
