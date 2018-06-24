<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="server-hostname" select="/icecast/hostname" />
    <xsl:param name="server-location" select="/icecast/location" />
    <xsl:param name="server-admin" select="/icecast/admin" />
    <xsl:param name="server-port" select="/icecast/listen-socket/port" />
    <xsl:param name="server-loglevel" select="/icecast/logging/loglevel" />

    <xsl:param name="pwd-source" />
    <xsl:param name="pwd-relay" />
    <xsl:param name="pwd-admin" />

    <xsl:template match="icecast">
        <xsl:element name="{name()}">
            <xsl:if test="$server-hostname">
                <hostname><xsl:value-of select="$server-hostname"/></hostname>
            </xsl:if>
            
            <xsl:if test="$server-location">
                <location><xsl:value-of select="$server-location"/></location>
            </xsl:if>

            <xsl:if test="$server-admin">
                <admin><xsl:value-of select="$server-admin"/></admin>
            </xsl:if>

            <listen-socket>
                <port>
                    <xsl:choose>
                        <xsl:when test="$server-port">
                            <xsl:value-of select="$server-port" />
                        </xsl:when>
                        <xsl:otherwise>50000</xsl:otherwise>
                    </xsl:choose>
                </port>
                <bind-address>::</bind-address>
            </listen-socket>

            <xsl:for-each select="authentication">
                <xsl:call-template name="auth_block">
                    <xsl:with-param name="source-password" select="$pwd-source" />
                    <xsl:with-param name="relay-password" select="$pwd-relay" />
                    <xsl:with-param name="admin-password" select="$pwd-admin" />
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="mount[@type='default']">
                <xsl:call-template name="mount_block" />
            </xsl:for-each>

            <xsl:for-each select="limits|directory|http-headers|relay|paths|security|mount[@type='normal']">
                <xsl:call-template name="deep_copy" />
            </xsl:for-each>

            <logging>
                <accesslog>-</accesslog>
                <errorlog>-</errorlog>
                <loglevel><xsl:value-of select="$server-loglevel" /></loglevel>
            </logging>

        </xsl:element>
    </xsl:template>

    <xsl:template name="deep_copy">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:copy-of select="child::*" />
        </xsl:copy>
    </xsl:template>

    <xsl:template name="mount_block">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:copy-of select="child::*" />
            <on-connect>/usr/lib/icecast-rec/icecast-on-connect</on-connect>
            <on-disconnect>/usr/lib/icecast-rec/icecast-on-disconnect</on-disconnect>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="auth_block">
        <xsl:param name="source-password" />
        <xsl:param name="relay-password" />
        <xsl:param name="admin-password" />
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:copy-of select="child::*[not (name()='source-password' or name()='relay-password' or name()='admin-password')]" />

            <xsl:choose>
                <xsl:when test="$source-password">
                    <source-password>
                        <xsl:value-of select="$source-password"/>
                    </source-password>
                </xsl:when>
                <xsl:when test="source-password">
                    <source-password>
                        <xsl:value-of select="source-password"/>
                    </source-password>
                </xsl:when>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="$relay-password">
                    <relay-password>
                        <xsl:value-of select="$relay-password"/>
                    </relay-password>
                </xsl:when>
                <xsl:when test="relay-password">
                    <relay-password>
                        <xsl:value-of select="relay-password"/>
                    </relay-password>
                </xsl:when>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="$admin-password">
                    <admin-password>
                        <xsl:value-of select="$admin-password"/>
                    </admin-password>
                </xsl:when>
                <xsl:when test="admin-password">
                    <admin-password>
                        <xsl:value-of select="admin-password"/>
                    </admin-password>
                </xsl:when>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
