<xsl:stylesheet xmlns:x="http://www.w3.org/2001/XMLSchema"
				version="1.0" exclude-result-prefixes="xsl ddwrt msxsl rssaggwrt"
				xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime"
				xmlns:rssaggwrt="http://schemas.microsoft.com/WebParts/v3/rssagg/runtime"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt"
				xmlns:rssFeed="urn:schemas-microsoft-com:sharepoint:RSSAggregatorWebPart"
				xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"
				xmlns:rss1="http://purl.org/rss/1.0/" xmlns:atom="http://www.w3.org/2005/Atom"
				xmlns:itunes="http://www.itunes.com/dtds/podcast-1.0.dtd"
				xmlns:atom2="http://purl.org/atom/ns#">

	<xsl:param name="rss_FeedLimit">5</xsl:param>
	<xsl:param name="rss_ExpandFeed">false</xsl:param>
	<xsl:param name="rss_LCID">1033</xsl:param>
	<xsl:param name="rss_WebPartID">RSS_Viewer_WebPart</xsl:param>
	<xsl:param name="rss_alignValue">left</xsl:param>
	<xsl:param name="rss_IsDesignMode">True</xsl:param>

	<xsl:template match="rss">
		<xsl:call-template name="RSSMainTemplate"/>
	</xsl:template>

	<xsl:template match="rdf:RDF">
		<xsl:call-template name="RDFMainTemplate"/>
	</xsl:template>

	<xsl:template match="atom:feed">
		<xsl:call-template name="ATOMMainTemplate"/>
	</xsl:template>

	<xsl:template match="atom2:feed">
		<xsl:call-template name="ATOM2MainTemplate"/>
	</xsl:template>

	<xsl:template name="RSSMainTemplate" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:variable name="Rows" select="channel/item"/>
		<xsl:variable name="RowCount" select="count($Rows)"/>
		<div class="slm-layout-main" >
			<div class="groupheader item medium">
				<a href="{ddwrt:EnsureAllowedProtocol(string(channel/link))}">
					<xsl:value-of select="channel/title"/>
				</a>
			</div>
			<xsl:call-template name="RSSMainTemplate.body">
				<xsl:with-param name="Rows" select="$Rows"/>
				<xsl:with-param name="RowCount" select="count($Rows)"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="RSSMainTemplate.body" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:param name="Rows"/>
		<xsl:param name="RowCount"/>
		<xsl:for-each select="$Rows">
			<xsl:variable name="CurPosition" select="position()" />
			<xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
			<xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
			<xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">
				<div class="item link-item" >
					<a href="{ddwrt:EnsureAllowedProtocol(string(link))}" target="_blank">
						<xsl:value-of select="title"/>
					</a>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="RDFMainTemplate" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:variable name="Rows" select="rss1:item"/>
		<xsl:variable name="RowCount" select="count($Rows)"/>
		<div class="slm-layout-main" >
			<div class="groupheader item medium">
				<a href="{ddwrt:EnsureAllowedProtocol(string(rss1:channel/rss1:link))}">
					<xsl:value-of select="rss1:channel/rss1:title"/>
				</a>
			</div>
			<xsl:call-template name="RDFMainTemplate.body">
				<xsl:with-param name="Rows" select="$Rows"/>
				<xsl:with-param name="RowCount" select="count($Rows)"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="RDFMainTemplate.body" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:param name="Rows"/>
		<xsl:param name="RowCount"/>
		<xsl:for-each select="$Rows">
			<xsl:variable name="CurPosition" select="position()" />
			<xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
			<xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
			<xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">
				<div class="item link-item" >
					<a href="{ddwrt:EnsureAllowedProtocol(string(rss1:link))}" target="_blank">
						<xsl:value-of select="rss1:title"/>
					</a>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="ATOMMainTemplate" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:variable name="Rows" select="atom:entry"/>
		<xsl:variable name="RowCount" select="count($Rows)"/>
		<div class="slm-layout-main" >
			<div class="groupheader item medium">
				<a href="{ddwrt:EnsureAllowedProtocol(string(atom:link[@rel='alternate']/@href))}">
					<xsl:value-of select="atom:title"/>
				</a>
			</div>
			<xsl:call-template name="ATOMMainTemplate.body">
				<xsl:with-param name="Rows" select="$Rows"/>
				<xsl:with-param name="RowCount" select="count($Rows)"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="ATOMMainTemplate.body" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:param name="Rows"/>
		<xsl:param name="RowCount"/>
		<xsl:for-each select="$Rows">
			<xsl:variable name="CurPosition" select="position()" />
			<xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
			<xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
			<xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">
				<div class="item link-item" >
					<a href="{ddwrt:EnsureAllowedProtocol(string(atom:link[@rel='alternate']/@href))}" target="_blank">
						<xsl:value-of select="atom:title"/>
					</a>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="ATOM2MainTemplate" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:variable name="Rows" select="atom2:entry"/>
		<xsl:variable name="RowCount" select="count($Rows)"/>
		<div class="slm-layout-main" >
			<div class="groupheader item medium">
				<a href="{ddwrt:EnsureAllowedProtocol(string(atom2:link/@href))}">
					<xsl:value-of select="atom2:title"/>
				</a>
			</div>
			<div class="groupheader item medium">
				<a href="{ddwrt:EnsureAllowedProtocol(string(atom2:link/@href))}">
					<xsl:value-of select="atom2:title"/>
				</a>
			</div>
			<xsl:call-template name="ATOM2MainTemplate.body">
				<xsl:with-param name="Rows" select="$Rows"/>
				<xsl:with-param name="RowCount" select="count($Rows)"/>
			</xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="ATOM2MainTemplate.body" xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
		<xsl:param name="Rows"/>
		<xsl:param name="RowCount"/>
		<xsl:for-each select="$Rows">
			<xsl:variable name="CurPosition" select="position()" />
			<xsl:variable name="RssFeedLink" select="$rss_WebPartID" />
			<xsl:variable name="CurrentElement" select="concat($RssFeedLink,$CurPosition)" />
			<xsl:if test="($CurPosition &lt;= $rss_FeedLimit)">
				<div class="item link-item" >
					<a href="{ddwrt:EnsureAllowedProtocol(string(atom:link/@href))}" target="_blank">
						<xsl:value-of select="atom2:title"/>
					</a>
				</div>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
