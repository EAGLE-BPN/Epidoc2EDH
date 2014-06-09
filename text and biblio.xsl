<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="/">
        <html><table><tr>
            <th>TM uri</th>
            <th>Text</th>
            <th>Bibliography</th>
        </tr>
            <xsl:for-each select="//record">
                <tr>
                    <td><a><xsl:attribute name="href"><xsl:value-of select="tmUri"/></xsl:attribute>Link</a></td>
                    <td><xsl:value-of select="textus"/></td>
                    <td><xsl:value-of select="lit"/></td>
                </tr>
            </xsl:for-each>
        </table>
        </html>
    </xsl:template>
</xsl:stylesheet>