<%@page import="org.apache.commons.lang3.StringUtils"%>
<%@page import="org.apache.sling.api.resource.Resource"%>
<%@page import="org.apache.sling.api.resource.ValueMap"%>
<%@page import="org.apache.sling.api.request.RequestDispatcherOptions"%>
<%@page import="org.apache.jackrabbit.util.Text"%>
<%@page import="com.adobe.granite.ui.components.Value"%>
<%@page import="com.day.cq.commons.jcr.JcrConstants"%>
<%@page import="io.wcm.config.api.Configuration"%>
<%@page import="io.wcm.sling.commons.resource.ImmutableValueMap"%>
<%@page import="io.wcm.wcm.ui.granite.resource.GraniteUiSyntheticResource"%>
<%@include file="../../global/global.jsp" %><%

String rootPath = null;
String contentPath = (String)request.getAttribute(Value.CONTENTPATH_ATTRIBUTE);
if (contentPath != null) {
  if (StringUtils.contains(contentPath, "/" + JcrConstants.JCR_CONTENT + "/")) {
    contentPath = StringUtils.substringBefore(contentPath, "/" + JcrConstants.JCR_CONTENT + "/");
  }
	Resource contentResource = resourceResolver.getResource(contentPath);
	if (contentResource != null) {
	  // detect root path of current site via Configuration API
		Configuration conf = contentResource.adaptTo(Configuration.class);
		if (conf != null) {
		  // path browser does not allow to select root path itself - workaround: set parent path as root path
		  rootPath = Text.getRelativeParent(conf.getConfigurationId(), 1);
		}
	}
}

ValueMap overwriteProperties;
if (rootPath != null) {
  overwriteProperties = ImmutableValueMap.of("rootPath", rootPath);
}
else {
  overwriteProperties = ImmutableValueMap.of();
}

// simulate resource for dialog field def with new rootPath instead of configured one
Resource resourceWrapper = GraniteUiSyntheticResource.wrapMerge(resource, overwriteProperties);

RequestDispatcherOptions options = new RequestDispatcherOptions();
options.setForceResourceType("/libs/granite/ui/components/foundation/form/pathbrowser");
RequestDispatcher dispatcher = slingRequest.getRequestDispatcher(resourceWrapper, options);
dispatcher.include(slingRequest, slingResponse);

%>