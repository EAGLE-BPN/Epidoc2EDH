<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <html><table><tr>
            <th>Name</th>
            <th>Praenomen</th>
            <th>Nomen</th>
            <th>Cognomen</th>
            <th>Supernomen</th>
            <th>Tribus</th>
        </tr>
        <xsl:for-each select="//Namen">
            <tr>
                <td><xsl:value-of select="name"/></td>
                <td><xsl:value-of select="praenomen"/></td>
                <td><xsl:value-of select="nomen"/></td>
                <td><xsl:value-of select="cognomen"/></td>
                <td><xsl:value-of select="supernomen"/></td>
                <td><xsl:value-of select="tribus"/></td>
            </tr>
        </xsl:for-each>
        </table>
        </html>
    </xsl:template>
</xsl:stylesheet>