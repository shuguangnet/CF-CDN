@echo off
setlocal enabledelayedexpansion
rem ��������Ŀ¼������Ŀ¼
cd C:\Users\Administrator\Desktop\cloudflare-cdn-ip
rem ���CloudFlareע���˻�����
set auth_email=rajibtelecom4@gmail.com
rem ���CloudFlare�˻�key,λ������������ҳ�������½ǻ�ȡapi key��
set auth_key=2c5c2f7976ec072dd41bcecd7fa8b928ea05b
rem #�޸�Ϊ���������
set zone_name=52jiasu.online
rem �Զ����µĶ�������ǰ׺,����cloudflare��cdn��cl��gcore��cdn��gcore�����������֣�������Զ���ӡ�
set record_name=cl
rem ����������������������5�����������ֱ���cl1��cl2��cl3��cl4��cl5.   �������Ϣ������Ҫ�޸ģ������Զ����оͺ��ˡ�
set record_count=5
set record_type=A

for /F %%I in ('.\curl\bin\curl.exe --silent http://4.ipw.cn') do set PUBLIC_IP=%%I
echo '��ȷ�ϸû���û��ͨ���������IP��ַ�ǣ�'%PUBLIC_IP%
echo '��ӭ��עyoutuberС���ʼǣ�https://www.youtube.com/channel/UCfSvDIQ8D_Zz62oAd5mcDDg'

CloudflareST.exe -p 0
for /F %%I in ('.\curl\bin\curl.exe -X GET "https://api.cloudflare.com/client/v4/zones?name=%zone_name%" -H "X-Auth-Email: %auth_email%" -H "X-Auth-Key: %auth_key%" -H "Content-Type: application/json"') do set zone_identifier=%%I
echo zone_id:%zone_identifier:~18,32%

set /a n=0
for /f "tokens=1 delims=," %%i in (result.csv) do (
	if !n! neq 0 (
		for /F %%I in ('.\curl\bin\curl.exe -X GET "https://api.cloudflare.com/client/v4/zones/%zone_identifier:~18,32%/dns_records?name=%record_name%!record_count!.%zone_name%" -H "X-Auth-Email: %auth_email%" -H "X-Auth-Key: %auth_key%" -H "Content-Type: application/json"') do set record=%%I
		echo record_id:!record:~18,32!
		::echo "https://api.cloudflare.com/client/v4/zones/%zone_identifier:~18,32%/dns_records/!record:~18,32!" -H "X-Auth-Email: %auth_email%" -H "X-Auth-Key: %auth_key%" -H "Content-Type: application/json" --data "{\"type\":\"%record_type%\",\"name\":\"%record_name%!record_count!.%zone_name%\",\"content\":\"%%i\",\"ttl\":60,\"proxied\":false}"
		echo ����DNS��¼
		for /F %%I in ('.\curl\bin\curl.exe -X PUT "https://api.cloudflare.com/client/v4/zones/%zone_identifier:~18,32%/dns_records/!record:~18,32!" -H "X-Auth-Email: %auth_email%" -H "X-Auth-Key: %auth_key%" -H "Content-Type: application/json" --data "{\"type\":\"%record_type%\",\"name\":\"%record_name%!record_count!.%zone_name%\",\"content\":\"%%i\",\"ttl\":60,\"proxied\":false}"') do set result=%%I
		echo %record_name%!record_count!.%zone_name%������ַ����Ϊ:%%i
    	echo ���½����!result:~-41,14!		
	    )
	set /a n+=1
	set /a record_count-=1
	if !record_count! LEQ 0 (
		goto :END
	)
)
:END