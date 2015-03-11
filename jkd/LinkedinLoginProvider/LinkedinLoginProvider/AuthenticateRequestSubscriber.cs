using System;
using System.Web;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Dynamicweb;
using System.Diagnostics;

[Dynamicweb.Extensibility.Subscribe(Dynamicweb.Notifications.Standard.Application.AuthenticateRequest)]
public class AuthenticateRequestSubscriber : Dynamicweb.Extensibility.NotificationSubscriber
{
    public override void OnNotify(string notification, Dynamicweb.Extensibility.NotificationArgs args)
    {
        Dynamicweb.Notifications.Standard.Application.AuthenticateRequestArgs loadedArgs = args as Dynamicweb.Notifications.Standard.Application.AuthenticateRequestArgs;
        if (loadedArgs != null && HttpContext.Current != null)
        {
            if (HttpContext.Current.Request.Url.AbsolutePath.ToLower().Contains("signin-linkedin"))
            {
                loadedArgs.Handled = true;
            }                    
        }            
    }
}

