MonsterDistroPlatform = function (sDomain, sWidgetID, sToken, sDefaultKeyword, sDefaultLocation, bShowResultsInNewWindow, sJobSearchUrl) {
    this.Url = ('https:' == document.location.protocol ? 'https://' : 'http://') + sDomain;
    this.WidgetID = sWidgetID;
    this.Token = sToken;
    this.DefaultKeyword = sDefaultKeyword;
    this.DefaultLocation = sDefaultLocation;
    this.ShowResultsInNewWindow = bShowResultsInNewWindow;
    this.JobSearchUrl = sJobSearchUrl;
    this.AppendStyles();
};

MonsterDistroPlatform.prototype.AppendStyles = function () {
    var oHead = document.getElementsByTagName('head')[0];
    oCss = document.createElement('link');
    oCss.type = 'text/css';
    oCss.rel = 'stylesheet';
    sUrl = this.Url + ('https:' == document.location.protocol ? '/Resources/SecureJobSearchProxy.ashx' : '/Resources/JobSearchProxy.css');
    oCss.href = sUrl;
    if (this._oldCss) {
        oHead.removeChild(this._oldCss);
        this._oldCss = null;
    }
    oHead.appendChild(oCss);
    this._oldCss = oCss;
}

MonsterDistroPlatform.prototype.TrackClick = function (oSource) {
    if (this.TrackingUrls) {
        for (var i = 0; i < this.TrackingUrls.length; i++) {
            var oImg = document.createElement('img');
            oImg.style.width = '1px';
            oImg.style.height = '1px';
            oImg.alt = 'na';

            var sImageUrl = this.TrackingUrls[i].replace("[TICKS]", new Date().getTime().toString()).replace("[PROTOCOL]", document.location.protocol);
            oImg.src = sImageUrl;
            document.body.appendChild(oImg);
        }
    }
    return true;
}

MonsterDistroPlatform.prototype.fieldFocus = function (oElement, sDefaultValue) {
    if (oElement.value == sDefaultValue) {
        oElement.value = '';
    }
}

MonsterDistroPlatform.prototype.fieldBlur = function (oElement, sDefaultValue) {
    if (oElement.value == '') {
        oElement.value = sDefaultValue;
    }
}

MonsterDistroPlatform.prototype.KeywordsBlur = function (oSource) {
    this.fieldBlur(oSource, this.DefaultKeyword);
}

MonsterDistroPlatform.prototype.KeywordsFocus = function (oSource) {
    this.fieldFocus(oSource, this.DefaultKeyword);
}

MonsterDistroPlatform.prototype.ValidateDomain = function () {
    if (this.ValidWidgetDomains && this.ValidWidgetDomains.length != 0) {
        var sHostname = location.hostname.toLowerCase();
        for (var i = 0; i < this.ValidWidgetDomains.length; i++) {
            if (sHostname == this.ValidWidgetDomains[i].toLowerCase()) {
                return true;
            }
        }
        return false;
    }
    return true;
}

MonsterDistroPlatform.prototype.HideSeoLink = function () {
    this.AddEvent(window, 'load', function () {
        var oLink = document.getElementById('monsterBrowseLink' + this.Token);
        if (oLink != null) {
            oLink.style.display = 'none';
        }
    });
}

MonsterDistroPlatform.prototype.KeywordsKeyPress = function (oSource, oEvent) {
    var iKeycode = 0;
    if (window.event) {
        iKeycode = window.event.keyCode;
    } else {
        if (oEvent) {
            iKeycode = oEvent.which;
        }
    }

    if (iKeycode == 13) {
        this.Search();
        return false;
    }

    return true;
}

MonsterDistroPlatform.prototype.LocationBlur = function (oSource) {
    this.fieldBlur(oSource, this.DefaultLocation);
    var oLocationDiv = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'LocationDiv');
    setTimeout(function () {
        if (oLocationDiv != null) {
            oLocationDiv.style.display = 'none';
        }
    }, 200);
}

MonsterDistroPlatform.prototype.LocationFocus = function (oSource) {
    this.fieldFocus(oSource, this.DefaultLocation);
}

MonsterDistroPlatform.prototype.get_LocationInput = function () {
    return document.getElementById('MonsterDistroPlatform' + this.Token +'Location');
}

MonsterDistroPlatform.prototype.get_KeywordsInput = function () {
    return document.getElementById('MonsterDistroPlatform' + this.Token + 'Keywords');
}

MonsterDistroPlatform.prototype.LocationKeyPress = function (oSource, oEvent) {
    var iKeycode = 0;
    if (window.event) {
        iKeycode = window.event.keyCode;
    } else {
        if (oEvent) {
            iKeycode = oEvent.which;
        }
    }

    if (iKeycode == 13) {
        this.Search();
        return false;
    }

    if (oSource.value.length >= 2) {
        var oHead = document.getElementsByTagName('head')[0];
        oScript = document.createElement('script');
        oScript.type = 'text/javascript';
        var sUrl = this.Url + '/Services/WidgetHandler.ashx?Verb=LocationSuggestion&WidgetID=' + this.WidgetID;
        if (this.ExtraUrl) {
            sUrl = sUrl + this.ExtraUrl;
        }
        sUrl += '&Location=' + encodeURIComponent(oSource.value);
        oScript.src = sUrl;
        oHead.appendChild(oScript);
    }

    return true;
}

MonsterDistroPlatform.prototype.setLocation = function (element, x, y) {
    var oStyle = element.style;
    oStyle.position = "absolute";
    oStyle.left = x + "px";
    oStyle.top = y + "px";
}

MonsterDistroPlatform.prototype.getLocation = function (element) {
    if ((element.window && (element.window === element)) || element.nodeType === 9)
        return { 'X': 0, 'Y': 0 };

    var offsetX = 0;
    var offsetY = 0;
    var previous = null;
    for (var parent = element; parent; previous = parent, parent = parent.offsetParent) {
        var tagName = parent.tagName;
        offsetX += parent.offsetLeft || 0;
        offsetY += parent.offsetTop || 0;
    }
    var elementPosition = element.style.position;
    var elementPositioned = elementPosition && (elementPosition !== "static");
    for (var parent = element.parentNode; parent; parent = parent.parentNode) {
        tagName = parent.tagName;
        if ((tagName !== "BODY") && (tagName !== "HTML") && (parent.scrollLeft || parent.scrollTop) &&
      ((elementPositioned &&
      ((parent.style.overflow === "scroll") || (parent.style.overflow === "auto"))))) {
            offsetX -= (parent.scrollLeft || 0);
            offsetY -= (parent.scrollTop || 0);
        }
        var parentPosition = (parent && parent.style) ? parent.style.position : null;
        elementPositioned = elementPositioned || (parentPosition && (parentPosition !== "static"));
    }
    return { 'X': offsetX, 'Y': offsetY };
}

MonsterDistroPlatform.prototype.UpdateLocationSuggestions = function (sText) {
    var oLocation = this.getLocation(this.get_LocationInput());

    var oLocationDiv = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'LocationDiv');
    if (!oLocationDiv) {
        var oLocationSuggestionsElement = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'LocationSuggestions');
        var iWidth = parseInt(oLocationSuggestionsElement.value);
        oLocationDiv = document.createElement('div');
        oLocationDiv.id = 'MonsterJobSearchResultPlaceHolder' + this.Token + 'LocationDiv';
        oLocationDiv.className = 'xmns_distro_LocationDiv';
        oLocationDiv.style.width = iWidth.toString() + 'px';
        document.body.appendChild(oLocationDiv);
    }

    oLocationDiv.innerHTML = sText;
    oLocationDiv.style.display = 'block';
    oLocationDiv.style.zIndex = 9999;
    this.setLocation(oLocationDiv, oLocation.X, oLocation.Y + this.get_LocationInput().offsetHeight);
}

MonsterDistroPlatform.prototype.ForceSuggestion = function (oElement) {
    this.get_LocationInput().value = oElement.innerHTML.replace('<b>', '').replace('</b>', '').replace('<B>', '').replace('</B>', '');
    var oLocationSuggestionsElement = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'LocationDiv');
    oLocationSuggestionsElement.style.display = 'none';
}

// only on preview
MonsterDistroPlatform.prototype.UpdateSeoLink = function (sUrl) {
    var oSeoLink = document.getElementById('monsterBrowseLink');
    if (oSeoLink != null && sUrl != null && sUrl != '') {
        oSeoLink.href = sUrl;
    }
}

MonsterDistroPlatform.prototype.SearchAndSwitchTab = function (sTab) {
    this._activeTab = sTab;
    this.Search();
}

MonsterDistroPlatform.prototype.Search = function () {
    if (!this.ShowResultsInNewWindow) {
        var oHead = document.getElementsByTagName('head')[0];
        oScript = document.createElement('script');
        oScript.type = 'text/javascript';
        var sUrl = this.Url + '/Services/WidgetHandler.ashx?Verb=Refresh&WidgetID=' + this.WidgetID;
        if (this.ExtraUrl) {
            sUrl = sUrl + this.ExtraUrl;
        }
        if (this._activeTab) {
            sUrl += '&ActiveTab=' + this._activeTab;
        }
        sUrl += '&Where=';
        if (this.get_LocationInput().value != this.DefaultLocation) {
            sUrl += encodeURIComponent(this.get_LocationInput().value);
        }
        sUrl += '&Query=';
        if (this.get_KeywordsInput().value != this.DefaultKeyword) {
            sUrl += encodeURIComponent(this.get_KeywordsInput().value);
        }
        sUrl += '&CheckedCategoryIndexes=' + this.get_CheckedCategoryIndexes().toString();
        oScript.src = sUrl;
        oHead.appendChild(oScript);
    } else {
        this.TrackClick();

        var sUrl = this.JobSearchUrl;

        var oCountryAbbrevElement = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'CountryAbbrev');
        if (oCountryAbbrevElement != null && oCountryAbbrevElement.value != null && oCountryAbbrevElement.value != '') {
            sUrl += '&cy=' + oCountryAbbrevElement.value;
        }
        if (this.get_LocationInput().value != this.DefaultLocation) {
            sUrl += '&where=' + encodeURIComponent(this.get_LocationInput().value);
        }
        if (this.get_KeywordsInput().value != this.DefaultKeyword) {
            sUrl += '&q=' + encodeURIComponent(this.get_KeywordsInput().value);
        }
        window.open(sUrl, '_blank');
    }
}

MonsterDistroPlatform.prototype.get_CheckedCategoryIndexes = function () {
    var oCategories = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'TrakCategoriesClone');
    var sResult = '';
    if (!oCategories) {
        return sResult;
    }
    var nodeList = oCategories.getElementsByTagName('input');
    var bFirst = true;
    for (var i = 0; i < nodeList.length; i++) {
        if (nodeList[i].checked) {
            if (!bFirst) {
                sResult += ',';
            }
            sResult += i.toString();
            bFirst = false;
        }
    }
    return sResult;
}

MonsterDistroPlatform.prototype.ShowTrakCategories = function () {
    var oCategoriesStatus = document.getElementById('MonsterDistroPlatform' + this.Token + 'tc');
    var oLocation = this.getLocation(oCategoriesStatus);

    var oTrakCategoriesDiv = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'TrakCategoriesClone');
    if (!oTrakCategoriesDiv) {
        oTrakCategoriesDiv = document.createElement('div');
        oTrakCategoriesDiv.id = 'MonsterJobSearchResultPlaceHolder' + this.Token + 'TrakCategoriesClone';
        oTrakCategoriesDiv.className = 'xmns_distro_TrakCategoriesDiv';

        var oSource = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'TrakCategories');
        var sInnerHTML = oSource.innerHTML;
        oSource.innerHTML = '';
        oTrakCategoriesDiv.innerHTML = sInnerHTML;
        document.body.appendChild(oTrakCategoriesDiv);
    }

    oTrakCategoriesDiv.style.display = 'block';
    oTrakCategoriesDiv.style.position = 'absolute';
    oTrakCategoriesDiv.style.left = oLocation.X.toString() + 'px';
    oTrakCategoriesDiv.style.top = (oLocation.Y + 28).toString() + 'px';
}

MonsterDistroPlatform.prototype.HideTrakCategories = function () {
    var oCategories = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token + 'TrakCategoriesClone');
    oCategories.style.display = 'none';
    var nodeList = oCategories.getElementsByTagName('input');
    var iCount = 0;
    var bAll = true;
    for (var i = 0; i < nodeList.length; i++) {
        if (nodeList[i].checked) {
            iCount++;
        } else {
            bAll = false;
        }
    }
    var oCounter = document.getElementById('MonsterDistroPlatform' + this.Token + 'TrakCounter');
    if (bAll) {
        oCounter.innerHTML = this.MSG_284074;
    } else {
        oCounter.innerHTML = iCount.toString();
    }
};

MonsterDistroPlatform.prototype.ShowWidget = function (iWidth, iHeight, sText) {
    var oContainer = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token);
    if (oContainer == null) {
        document.write('<div id=\'MonsterJobSearchResultPlaceHolder' + this.Token + '\' class=\'xmns_distroph\'>' + sText + '</div>');
        oContainer = document.getElementById('MonsterJobSearchResultPlaceHolder' + this.Token);
    } else {
        oContainer.innerHTML = sText;
    }
    if (iWidth > 0) {
        oContainer.style.width = iWidth.toString() + 'px';
    }
    if (iHeight > 0) {
        oContainer.style.height = iHeight.toString() + 'px';
    }
}

MonsterDistroPlatform.prototype.AddEvent = function (obj, type, fn) {
    if (obj.attachEvent) {
        obj['e' + type + fn] = fn;
        obj[type + fn] = function () { obj['e' + type + fn](window.event); }
        obj.attachEvent('on' + type, obj[type + fn]);
    } else
        obj.addEventListener(type, fn, false);
}

var oWidgetNXAAAA_e_e = new MonsterDistroPlatform('publisher.monster.com','EAAQUeLsOxB7mqhf97nwIpkVXQ--','NXAAAA_e_e','Any Skills/Keywords','Any Location',false,'http://jobsearch.monster.com/Search.aspx?');
oWidgetNXAAAA_e_e.MSG_284074 = 'All';
oWidgetNXAAAA_e_e.TrackingUrls = [];
oWidgetNXAAAA_e_e.ValidWidgetDomains = ["iamtrask.github.io","www.iamtrask.github.io"];
if (oWidgetNXAAAA_e_e.ValidateDomain()) { 
  oWidgetNXAAAA_e_e.ShowWidget(400,0,'<div id="jobSearchResult" class="jobSearchResultDiv" style="width:400px;background-color:#FFFFFF" xmlns:ms="urn:schemas-microsoft-com:xslt">Search For Jobs On<a target="_blank" href="http://www.monster.com"><img alt="Monster Logo" src="http://media.newjobs.com/id/distro/neutral/slogo.gif" style="position:relative;top:1px;left:0px" /></a><div style="background-color:#800080" class="form"><div style="clear:both;height:10px"></div><div class="innerForm"><div class="b1" style="width:148px"><input type="text" class="keywords" maxlength="200" id="MonsterDistroPlatformNXAAAA_e_eKeywords" value="Machine Learning" onfocus="oWidgetNXAAAA_e_e.KeywordsFocus(this)" onblur="oWidgetNXAAAA_e_e.KeywordsBlur(this)" onkeypress="oWidgetNXAAAA_e_e.KeywordsKeyPress(this,event)" /></div><div class="b2">in</div><div class="b3" style="width:148px"><input type="text" class="location" id="MonsterDistroPlatformNXAAAA_e_eLocation" value="Any Location" onfocus="oWidgetNXAAAA_e_e.LocationFocus(this)" onblur="oWidgetNXAAAA_e_e.LocationBlur(this)" onkeypress="oWidgetNXAAAA_e_e.LocationKeyPress(this,event)" /></div><a class="search-button" onclick="oWidgetNXAAAA_e_e.Search()">&nbsp;</a><div style="clear:both"></div></div><div class="formBottom"></div></div><div><div style="clear:both"></div><div class="jobSearchResultRow"><a href="http://jobview.monster.com/Lead-Data-Scientist-Python-Big-Data-Machine-Learning-Job-New-York-City-NY-US-165028807.aspx" title="Lead Data Scientist - Python, Big Data, Machine Learning" target="_blank" class="fnt11" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Lead Data Scientist - Python, Big Data, Machine Lear...</a><br /><span class="fnt16" style="color:#008000">CyberCoders - New York City, New York, 10001 - Posted 1 days ago - $70,000.00 - $85,000.00 Per Year</span><br /><span style="color:#000000">CyberCoders Matching Great People with Great Companies Learn more about CyberCoders Data Scientist Apply New York City, NY Full-Time $70,000 - $85,000 Job Details Based in New York City, we are dat...</span><br /><a href="http://jobview.monster.com/Lead-Data-Scientist-Python-Big-Data-Machine-Learning-Job-New-York-City-NY-US-165028807.aspx" title="Lead Data Scientist - Python, Big Data, Machine Learning" class="fnt4" target="_blank" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Job Details &amp; Apply</a></div><br /><div class="jobSearchResultRow"><a href="http://jobview.monster.com/Machine-Learning-Engineer-Biotech-Pre-Clinical-Research-Company-Job-San-Mateo-CA-US-165028880.aspx" title="Machine Learning Engineer-Biotech Pre-Clinical Research Company" target="_blank" class="fnt11" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Machine Learning Engineer-Biotech Pre-Clinical Resea...</a><br /><span class="fnt16" style="color:#008000">CyberCoders - San Mateo, California, 94403 - Posted 1 days ago - $120,000.00 - $175,000.00 Per Year</span><br /><span style="color:#000000">CyberCoders Matching Great People with Great Companies Learn more about CyberCoders Machine Learning Engineer Apply San Mateo, CA Full-Time $120,000 - $175,000 Job Details If you are a Machine Lear...</span><br /><a href="http://jobview.monster.com/Machine-Learning-Engineer-Biotech-Pre-Clinical-Research-Company-Job-San-Mateo-CA-US-165028880.aspx" title="Machine Learning Engineer-Biotech Pre-Clinical Research Company" class="fnt4" target="_blank" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Job Details &amp; Apply</a></div><br /><div class="jobSearchResultRow"><a href="http://jobview.monster.com/Machine-Learning-Engineer-110-130K-Plus-free-lunch-everyday!-Job-Palo-Alto-CA-US-165028893.aspx" title="Machine Learning Engineer ($110-130K) Plus free lunch everyday!" target="_blank" class="fnt11" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Machine Learning Engineer ($110-130K) Plus free lunc...</a><br /><span class="fnt16" style="color:#008000">CyberCoders - Palo Alto, California, 94301 - Posted 1 days ago - $110,000.00 - $130,000.00 Per Year</span><br /><span style="color:#000000">CyberCoders Matching Great People with Great Companies Learn more about CyberCoders Machine Learning Engineer ($110-130K) Plus free lunch everyday! Apply Palo Alto, CA Full-Time $110,000 - $130,000...</span><br /><a href="http://jobview.monster.com/Machine-Learning-Engineer-110-130K-Plus-free-lunch-everyday!-Job-Palo-Alto-CA-US-165028893.aspx" title="Machine Learning Engineer ($110-130K) Plus free lunch everyday!" class="fnt4" target="_blank" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Job Details &amp; Apply</a></div><br /><div class="jobSearchResultRow"><a href="http://jobview.monster.com/Data-Scientist-Machine-Learning-Python-Hadoop-Job-Orange-CA-US-165029039.aspx" title="Data Scientist - Machine Learning, Python, Hadoop" target="_blank" class="fnt11" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Data Scientist - Machine Learning, Python, Hadoop</a><br /><span class="fnt16" style="color:#008000">CyberCoders - Orange, California, 92861 - Posted 1 days ago - $1.00 - $1.00 Per Year</span><br /><span style="color:#000000">CyberCoders Matching Great People with Great Companies Learn more about CyberCoders Data Scientist - Machine Learning, Python, Hadoop Apply Orange, CA Unspecified Job Details If you are a Data Scie...</span><br /><a href="http://jobview.monster.com/Data-Scientist-Machine-Learning-Python-Hadoop-Job-Orange-CA-US-165029039.aspx" title="Data Scientist - Machine Learning, Python, Hadoop" class="fnt4" target="_blank" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Job Details &amp; Apply</a></div><br /><div class="jobSearchResultRow"><a href="http://jobview.monster.com/Software-Engineer-C-Object-Oriented-MATLAB-Image-Processing-Machine-learning-Algorithms-Job-Milpitas-CA-US-165029193.aspx" title="Software Engineer ( C++ Object Oriented MATLAB Image Processing Machine learning Algorithms" target="_blank" class="fnt11" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Software Engineer ( C++ Object Oriented MATLAB Image...</a><br /><span class="fnt16" style="color:#008000">KLA - Tencor - Milpitas, California, 95035 - Posted 1 days ago</span><br /><span style="color:#000000">Job Description: Business Unit: The Wafer Inspection Division (WIN) is the world leader in the design and manufacture of advanced optical inspection tools for inline monitoring of process defects i...</span><br /><a href="http://jobview.monster.com/Software-Engineer-C-Object-Oriented-MATLAB-Image-Processing-Machine-learning-Algorithms-Job-Milpitas-CA-US-165029193.aspx" title="Software Engineer ( C++ Object Oriented MATLAB Image Processing Machine learning Algorithms" class="fnt4" target="_blank" onclick="oWidgetNXAAAA_e_e.TrackClick(this)">Job Details &amp; Apply</a></div><br /></div><input type="hidden" id="MonsterJobSearchResultPlaceHolderNXAAAA_e_eCountryAbbrev" value="US" /><input type="hidden" id="MonsterJobSearchResultPlaceHolderNXAAAA_e_eLocationSuggestions" value="148" /><div id="MonsterJobSearchResultPlaceHolderNXAAAA_e_eTrakCategories" style="width:68px;display:none"><div class="trakCategoriesInner">&nbsp;</div><div class="bottom"><a onclick="oWidgetNXAAAA_e_e.HideTrakCategories()">Close&nbsp;</a></div></div></div>');
} else { 
  oWidgetNXAAAA_e_e.ShowWidget(400,0,'This widget was registered for different domain. Please run it in under iamtrask.github.io or www.iamtrask.github.io.');
  oWidgetNXAAAA_e_e.HideSeoLink();
}
