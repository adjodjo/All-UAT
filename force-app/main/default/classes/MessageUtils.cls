public with sharing class MessageUtils {

    public Static String ErrorMessage(String Lang, String indice) {
        
        String myMessage = '';

        system.debug('la langue est '+Lang +' et indice est '+indice);

            if(Lang == 'en_US' && indice == 'message_1') myMessage = 'Missing Account identification, can not send email to no account';
            if(Lang == 'fr' && indice == 'message_1' ) myMessage = 'Compte inexistant, Impossible d\'envoyer un email à ce compte';

            if(Lang == 'en_US' && indice == 'message_2' ) myMessage ='Missing Contact Name, can not send email to this account without required Contact Information';
            if(Lang == 'fr' && indice == 'message_2' ) myMessage ='Impossible d\'envoyer un email à un compte sans informations du contact associé';

            if(Lang == 'en_US' && indice == 'message_3' ) myMessage ='Can not create new Case. Check the parameters or contact System Administrator.';
            if(Lang == 'fr' && indice == 'message_3' ) myMessage ='Erreur lors de la création du nouveau Cas. Vérifiez vos paramètres ou contactez l\'administrateur Système.';

            if(Lang == 'en_US' && indice == 'message_4' ) myMessage ='Can not create new History. Check the parameters or contact System Administrator.';
            if(Lang == 'fr' && indice == 'message_4' ) myMessage ='Erreur lors de la création du nouvel Historique. Vérifiez vos paramètres ou contactez l\'administrateur Système. ';

            if(Lang == 'en_US' && indice == 'message_5' ) myMessage ='Missing Account name or Account phone number. Check the parameters or contact System Administrator.';
            if(Lang == 'fr' && indice == 'message_5' ) myMessage ='Nom ou Numéro de téléphone du compte manquant. Vérifiez vos paramètres ou contactez l\'administrateur Système.';

            if(Lang == 'en_US' && indice == 'message_6' ) myMessage ='Need History before send new email. Check parameters or contact Administrator System';
            if(Lang == 'fr' && indice == 'message_6' ) myMessage ='Une historique doit être crée avant tout nouvel envoi d\'email. Vérifiez vos paramètres ou contactez l\'administrateur Système. ';

            if(Lang == 'en_US' && indice == 'message_7' ) myMessage ='Missing Email address, can not send email to this account without required Contact Information';
            if(Lang == 'fr' && indice == 'message_7' ) myMessage ='Impossible d\'envoyer un email à un compte sans informations du contact associé';

            if(Lang == 'en_US' && indice == 'message_8' ) myMessage ='Missing contract, template or other sending information, can not send email.';
            if(Lang == 'fr' && indice == 'message_8' ) myMessage ='Impossible d\'envoyer l\'email, il manque des informations de contrat, de gabari ou tout autres paramètres d\'envoi.';

            if(Lang == 'en_US' && indice == 'message_9' ) myMessage ='Can not send email, missing required information. Contact System Administrator.';
            if(Lang == 'fr' && indice == 'message_9' ) myMessage ='Impossible d\'envoyer l\'email, il manque des informations. Contactez l\'administrateur Système.';
        
        	if(Lang == 'en_US' && indice == 'message_10' ) myMessage ='Error occurred while processing information. Contact System Administrator.';
            if(Lang == 'fr' && indice == 'message_10' ) myMessage ='Erreur survenue lors du traitement des informations. Contactez l\'administrateur Système.';
        
        	if(Lang == 'en_US' && indice == 'message_11' ) myMessage ='Missing Agent user information. Contact System Administrator.';
            if(Lang == 'fr' && indice == 'message_11' ) myMessage ='Informations de l\'agent manquantes. Contactez l\'administrateur Système.';
        
        	if(Lang == 'en_US' && indice == 'message_12' ) myMessage ='Can not create new Account. Check the parameters or contact System Administrator.';
            if(Lang == 'fr' && indice == 'message_12' ) myMessage ='Erreur lors de la création du nouveau Compte client. Vérifiez vos paramètres ou contactez l\'administrateur Système.';

        	if(Lang == 'en_US' && indice == 'message_13') myMessage = 'Missing information to complete historisation operation';
            if(Lang == 'fr' && indice == 'message_13' ) myMessage = 'Manque d\'information pour compléter l\'opéreation d\'historisation';
        
        	if(Lang == 'en_US' && indice == 'message_14') myMessage = 'Unable to take case because you will have more than expected Cases in your queue.';
            if(Lang == 'fr' && indice == 'message_14' ) myMessage = 'Impossible de prendre en charge la requête car vous aurez plus de cas que prévu de requête dans votre file d\'attente.';
        
        	if(Lang == 'en_US' && indice == 'message_15') myMessage = 'You can not Closed Case without Case Type or sub-type.';
            if(Lang == 'fr' && indice == 'message_15' ) myMessage = 'Impossible de fermer une requête sans attribuer un type ou un sous-type.';
        
        	if(Lang == 'en_US' && indice == 'message_16') myMessage = 'There are some missing information or Unable to take case because because you will have more than expected Cases in your queue.';
            if(Lang == 'fr' && indice == 'message_16' ) myMessage = 'Il y a un manque d\'information ou Impossible de prendre en charge la requête car vous aurez plus de cas que prévu de requête dans votre file d\'attente.';

            if(Lang == 'en_US' && indice == 'message_17') myMessage = 'You can not Close escalated Case.';
            if(Lang == 'fr' && indice == 'message_17' ) myMessage = 'Impossible de fermer une requête qui a été escaladé.';
        
        	if(Lang == 'en_US' && indice == 'message_18') myMessage = 'you don\'t have the necessary privileges to edit this record. See your administrator for help.';
            if(Lang == 'fr' && indice == 'message_18' ) myMessage = 'vous ne disposez pas des privilèges nécessaires pour modifier cet enregistrement. Consultez votre administrateur pour obtenir de l\'aide.';
            

        
        
        
        
        return myMessage;

    }
}