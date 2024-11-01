# Court Reserve Mobile App - Flutter

## Project
- Flutter version: 3.16.4
- Dart version: 3.2.3
- Architecture: 
  - MVVM
  - RxDart
  - Triple Pattern (UIModel -> handle success, loading, error)
- How to generate files: `dart run build_runner build`

## Presenting the app

### Register | Login | Forgot Password
<p align="middle">
  <img src="/.documentation/Auth_Register.png" width="250" />
  <img src=".documentation/Auth_Login.png" width="250" /> 
  <img src=".documentation/Auth_Forgot_Password.png" width="250" /> 
</p>

* Forgot Password Feature - Deeplinks  
https://github.com/user-attachments/assets/8f596a49-e128-4346-9858-e23942147f97

### Tennis Courts Search
<p align="middle">
  <img src="/.documentation/Courts_Customer.png" width="250" />
  <img src=".documentation/Courts_Customer_Search.png" width="250" /> 
</p>

* If a user is not logged in and he tires to select a court, a popup is showed.
* If the user is logged in then he can see the details and make a reservation.
<p align="middle">
  <img src="/.documentation/Courts_Select_Not_LoggedIn.png" width="250" />
  <img src="/.documentation/Courts_Tennis_Details_Default.png" width="250" />
</p>

* The user can modify the hours and the price is updated accordingly
<p align="middle">
  <img src="/.documentation/Courts_Tennis_Details_Default.png" width="250" />
  <img src="/.documentation/Courts_Tennis_Details_4Hours.png" width="250" />
</p>

* The user can see pending, current and past reservations
* Here he can access reservation options
<p align="middle">
  <img src="/.documentation/MyReservations_All.png" width="250" />
  <img src="/.documentation/MyReservations_Options.png" width="250" />
</p>
<p align="middle">
  <img src="/.documentation/Courts_TSelectAndReserve.png" width="250" />
  <img src="/.documentation/MyReservations_Updated.png" width="250" />
</p>

### Not Logged In Profile | Logged In Profile | Membership Plan Activated Profile
* User can login and logout 
* User can activate / deactivate membership plans
* If a membership plan is active, then the user does not need to pay the reservation, and the price is 0
<p align="middle">
  <img src="/.documentation/Profile_Not_LoggedIn.png" width="250" />
  <img src="/.documentation/Profile_LoggedIn.png" width="250" />
  <img src="/.documentation/Profile_LoggedIn_GoldPlan.png" width="250" />
</p>

### Host - Add Tennis Court
* Host can add tennis courts and view all their courts
<p align="middle">
  <img src="/.documentation/TennisCourt_Add.png" width="250" />
  <img src="/.documentation/TennisCourt_Add_Filled.png" width="250" />
  <img src="/.documentation/TennisCourt_Add_MyCourts.png" width="250" />
</p>
<p align="middle">
  <img src="/.documentation/TennisCourt_Add2.png" width="250" />
  <img src="/.documentation/TennisCourt_Add2_MyCourts.png" width="250" />
</p>
* Host can edit tennis court details
<p align="middle">
  <img src="/.documentation/TennisCourt_Edit.png" width="250" />
  <img src="/.documentation/TennisCourt_Edit_NewName.png" width="250" />
</p>

* Hosts can view reservations and accept/decline them
<p align="middle">
  <img src="/.documentation/TennisCourt_ViewReservations.png" width="250" />
  <img src="/.documentation/TennisCourt_ViewReservations_InPending.png" width="250" />
  <img src="/.documentation/TennisCourt_ViewReservations_Accept.png" width="250" />
</p>

https://github.com/user-attachments/assets/8f596a49-e128-4346-9858-e23942147f97

