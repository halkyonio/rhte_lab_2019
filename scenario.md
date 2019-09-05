** To be fleshed out **

- Connect to a cluster
- Create a new namespace
- Create a new directory and cd to it
- Create a new client project using the `client` template in a `fruit-client-sb` directory: `hal component spring-boot fruit-client-sb`
- Create a new backend project using the `crud` template in a `fruit-backend-sb` directory: `hal component spring-boot fruit-backend-sb`
- Modify the `application.properties` for the backend and client so that they match the operator demo apps but no need to add link/capability dekorate details (list of what's required here to be defined)
- Build both projects: `mvn package -f fruit-client-sb,fruit-backend-sb`
- Push components: `hal component push -t fruit-client-sb,fruit-backend-sb`
- Wait… :(
- Components should be ready but not working: `kubectl get cp`
- Create a capability for the `fruit-backend-sb` component: `hal capability` provide the parameters so that it matches the operator demo
- Check the capability status: `kubectl get capabilities`
- Create a link targeting the `fruit-client-sb` component: `hal link` and provide the parameters to match the operator demo
- Check the link status: `kubectl get links`
- Wait for things to be settled
- Try the backend service to see if it works
- Try the client service to see if it works
