<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" encoding="utf-8" omit-xml-declaration="no"/>
    <xsl:template match="testsuites">
        <xsl:element name="testsuites">
            <xsl:attribute name="tests">
                <xsl:value-of select="@tests"/>
            </xsl:attribute>
            <xsl:attribute name="errors">
                <xsl:value-of select="@errors"/>
            </xsl:attribute>
            <xsl:attribute name="failures">
                <xsl:value-of select="@failures"/>
            </xsl:attribute>
            <xsl:apply-templates select="testsuite"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="testsuite">
        <xsl:element name="testsuite">
            <xsl:attribute name="name">
                <xsl:value-of select="substring-before(substring-after(*/@name, '.'), '.')"/>
            </xsl:attribute>
            <xsl:attribute name="timestamp">
                <xsl:value-of select="@start"/>
            </xsl:attribute>
            <xsl:attribute name="tests">
                <xsl:value-of select="@tests"/>
            </xsl:attribute>
            <xsl:attribute name="errors">
                <xsl:value-of select="@errors"/>
            </xsl:attribute>
            <xsl:attribute name="failures">
                <xsl:value-of select="@failures"/>
            </xsl:attribute>
            <xsl:apply-templates select="testcase"/>
        </xsl:element>
    </xsl:template>
    <xsl:template match="testcase">
        <xsl:element name="testcase">
            <!-- TODO: split name in to class name / test name -->
            <xsl:attribute name="name">
                <xsl:value-of select="@name"/>
            </xsl:attribute>
            <xsl:attribute name="time">
                <xsl:value-of select="@time"/>
            </xsl:attribute>
            <xsl:if test="system-out">
                <xsl:element name="system-out">
                    <xsl:value-of select="system-out"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="system-err">
                <xsl:element name="system-err">
                    <xsl:value-of select="system-err"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="failure">
                <xsl:element name="failure">
                    <xsl:attribute name="type">
                        <xsl:value-of select="failure/@type"/>
                    </xsl:attribute>
                    <xsl:attribute name="message">
                        <xsl:value-of select="failure/@message"/>
                    </xsl:attribute>
                    <xsl:value-of select="failure"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="error">
                <xsl:element name="error">
                    <xsl:attribute name="type">
                        <xsl:value-of select="error/@type"/>
                    </xsl:attribute>
                    <xsl:attribute name="message">
                        <xsl:value-of select="error/@message"/>
                    </xsl:attribute>
                    <xsl:value-of select="error"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="skipped">
                <xsl:element name="skipped">
                    <xsl:attribute name="message">
                        <xsl:value-of select="skipped"/>
                    </xsl:attribute>
                </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>
</xsl:stylesheet>

