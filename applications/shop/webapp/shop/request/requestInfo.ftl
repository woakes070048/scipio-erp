<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<@section title="${uiLabelMap.OrderRequest}&nbsp;${custRequest.custRequestId}&nbsp;${uiLabelMap.CommonInformation}">
        <@table type="generic" class="${styles.table_basic!}" cellspacing="0"> <#-- orig: class="basic-table" -->
            <#-- request header information -->
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.CommonType}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    ${(custRequestType.get("description",locale))!(custRequest.custRequestTypeId)!}
                </@td>
            </@tr>
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <#-- request status information -->
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.CommonStatus}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    ${(statusItem.get("description", locale))!(custRequest.statusId)!}
                </@td>
            </@tr>
            <#-- party -->
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <@tr>
                 <@td align="right" valign="top" width="15%" class="label">
                     &nbsp;${uiLabelMap.PartyPartyId}
                 </@td>
                 <@td width="5%">&nbsp;</@td>
                 <@td valign="top" width="80%">
                    ${custRequest.fromPartyId!}
                 </@td>
            </@tr>
            <#-- request name -->
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.CommonName}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    ${custRequest.custRequestName!}
                </@td>
            </@tr>
            <#-- request description -->
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.CommonDescription}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    ${custRequest.description!}
                </@td>
            </@tr>
            <#-- request currency -->
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.CommonCurrency}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    <#if currency??>${currency.get("description", locale)?default(custRequest.maximumAmountUomId!)}</#if>
                </@td>
            </@tr>
            <#-- request currency -->
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.ProductProductStore}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    <#if store??>${store.storeName!(custRequest.productStoreId!)}</#if>
                </@td>
            </@tr>
            <#-- request comment -->
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.CommonInternalComment}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    ${custRequest.internalComment!}
                </@td>
            </@tr>
            <#-- request reason -->
            <@tr type="util"><@td colspan="7"><hr /></@td></@tr>
            <@tr>
                <@td align="right" valign="top" width="15%" class="label">
                    &nbsp;${uiLabelMap.CommonReason}
                </@td>
                <@td width="5%">&nbsp;</@td>
                <@td valign="top" width="80%">
                    ${custRequest.reason!}
                </@td>
            </@tr>
        </@table>
</@section>
